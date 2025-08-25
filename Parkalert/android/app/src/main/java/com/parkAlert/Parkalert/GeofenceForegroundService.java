package com.parkAlert.Parkalert;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.location.Location;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashSet;
import java.util.Set;
import androidx.core.app.NotificationCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import android.content.SharedPreferences;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class GeofenceForegroundService extends Service {
    private static final String CHANNEL_ID = "GeofenceServiceChannel";
    private static final String EVENT_CHANNEL_ID = "geofence_event_channel";

    private void createEventChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    EVENT_CHANNEL_ID,
                    "Geofence Events",
                    NotificationManager.IMPORTANCE_HIGH
            );
            channel.enableLights(true);
            channel.enableVibration(true);
            channel.setLightColor(Color.BLUE);
            getSystemService(NotificationManager.class).createNotificationChannel(channel);
        }
    }
    private FusedLocationProviderClient fusedLocationClient;
    private LocationCallback locationCallback;
    private boolean isInsideZone = false;
    private static final double EDGE_BUFFER_METERS = 2.0;
    public static MethodChannel channel = null;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("GeofenceService", "✅ GeofenceForegroundService started");

        createEventChannel();
        createNotificationChannel();
        startForeground(1001, buildNotification("Geofence monitoring active").build());

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        locationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult result) {
                if (result == null) return;
                for (Location loc : result.getLocations()) {
                    Log.d("GeofenceService", "Location update: " + loc.getLatitude() + ", " + loc.getLongitude());
        checkGeofence(loc);
                }
            }
        };

        startLocationUpdates();
    }

    private void startLocationUpdates() {
        LocationRequest request = LocationRequest.create()
                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .setInterval(5000)
                .setSmallestDisplacement(1f);

        fusedLocationClient.requestLocationUpdates(request, locationCallback, getMainLooper());
    }

    private void checkGeofence(Location location) {
    List<Zone> zones = loadZonesFromPrefs();
    boolean insideAnyZone = false;
    String activeZoneName = null;

    Log.d("GeofenceService", "Checking location: " + location.getLatitude() + ", " + location.getLongitude());
    Log.d("GeofenceService", "Total zones loaded: " + zones.size());

    for (Zone zone : zones) {
        Log.d("GeofenceService", "Checking zone: " + zone.name + ", isOn: " + zone.isOn + ", points: " + (zone.points != null ? zone.points.size() : 0));

        // Skip if zone is off
        if (!zone.isOn) {
            Log.d("GeofenceService", "Skipping zone '" + zone.name + "' - isOn=false");
            continue;
        }

        // Skip if zone has no points or too few points for a polygon
        if (zone.points == null || zone.points.size() < 3) {
            Log.d("GeofenceService", "Skipping zone '" + zone.name + "' - invalid points");
            continue;
        }

        // Check if inside polygon or near edge
        boolean insidePolygon = isPointInPolygon(location.getLatitude(), location.getLongitude(), zone.points);
        boolean nearEdge = isNearPolygonEdge(location.getLatitude(), location.getLongitude(), zone.points, EDGE_BUFFER_METERS);
        
        Log.d("GeofenceService", "Zone '" + zone.name + "' - inside: " + insidePolygon + ", near edge: " + nearEdge);

        if (insidePolygon || nearEdge) {
            insideAnyZone = true;
            activeZoneName = zone.name;
            Log.d("GeofenceService", "INSIDE ZONE: " + zone.name);
            break;
        }
    }

    Log.d("GeofenceService", "Final result - insideAnyZone: " + insideAnyZone + ", isInsideZone: " + isInsideZone);

    if (insideAnyZone && !isInsideZone) {
        Log.d("GeofenceService", "Entered ALERT zone: " + (activeZoneName != null ? activeZoneName : "zone"));
        showEventNotification("Entered Zone", activeZoneName != null ? activeZoneName : "zone");
        if (channel != null) {
            channel.invokeMethod("enteredZone", activeZoneName != null ? activeZoneName : "zone");
        }
    } else if (!insideAnyZone && isInsideZone) {
        Log.d("GeofenceService", "Exited ALERT zone");
        showEventNotification("Exited ALERT Zone", "geofenced area");
        if (channel != null) {
            channel.invokeMethod("exitedZone", "geofenced area");
        }
    }

    isInsideZone = insideAnyZone;
    Log.d("GeofenceService", "================ - insideAnyZone: " + insideAnyZone + ", isInsideZone: " + isInsideZone);

    // Save state to SharedPreferences
    getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            .edit()
            .putBoolean("flutter.insideGeofence", isInsideZone)
            .apply();
}
    // Load zones saved in Flutter SharedPreferences
 private List<Zone> loadZonesFromPrefs() {
    List<Zone> zones = new ArrayList<>();
    try {
        SharedPreferences prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        // Get the raw string value
        String zonesData = prefs.getString("flutter.zones", null);
        if (zonesData == null) {
            zonesData = prefs.getString("zones", null);
        }
        
        if (zonesData != null) {
            Log.d("GeofenceService", "Raw zones data: " + zonesData);
            
            // Check if it's a Flutter list prefix
            if (zonesData.startsWith("VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!")) {
                // This is a Flutter list - remove the prefix and parse as JSON array
                String jsonArrayString = zonesData.substring("VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!".length());
                Log.d("GeofenceService", "JSON array string: " + jsonArrayString);
                
                try {
                    JSONArray jsonArray = new JSONArray(jsonArrayString);
                    for (int i = 0; i < jsonArray.length(); i++) {
                        String zoneJsonString = jsonArray.getString(i);
                        JSONObject obj = new JSONObject(zoneJsonString);
                        zones.add(parseZoneFromJson(obj));
                    }
                    Log.d("GeofenceService", "Loaded " + zones.size() + " zones from Flutter list");
                } catch (Exception e) {
                    Log.e("GeofenceService", "Failed to parse Flutter list JSON: " + e.getMessage());
                }
            } else {
                // Try to parse as regular JSON array (without Flutter prefix)
                try {
                    JSONArray jsonArray = new JSONArray(zonesData);
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject obj = jsonArray.getJSONObject(i);
                        zones.add(parseZoneFromJson(obj));
                    }
                    Log.d("GeofenceService", "Loaded " + zones.size() + " zones from regular JSON array");
                } catch (Exception e) {
                    Log.e("GeofenceService", "Failed to parse regular JSON array: " + e.getMessage());
                }
            }
        } else {
            Log.d("GeofenceService", "No zones data found in SharedPreferences");
        }
        
    } catch (Exception e) {
        Log.e("GeofenceService", "Failed to load zones: " + e.getMessage());
        e.printStackTrace();
    }
    return zones;
}

// Helper method to parse a zone from JSON
private Zone parseZoneFromJson(JSONObject obj) throws Exception {
    String name = obj.optString("name", "zone");
    boolean isOn = obj.optBoolean("isOn", false);

    JSONArray pointsJson = obj.optJSONArray("points");
    List<LatLng> points = new ArrayList<>();
    if (pointsJson != null) {
        for (int j = 0; j < pointsJson.length(); j++) {
            JSONObject p = pointsJson.getJSONObject(j);
            points.add(new LatLng(p.getDouble("lat"), p.getDouble("lng")));
        }
    }
    
    return new Zone(name, isOn, points);
}

    private boolean isPointInPolygon(double lat, double lng, List<LatLng> polygon) {
        if (polygon.size() < 3) return false;

        boolean inside = false;
        int j = polygon.size() - 1;
        for (int i = 0; i < polygon.size(); i++) {
            LatLng pi = polygon.get(i);
            LatLng pj = polygon.get(j);

            if ((pi.lng > lng) != (pj.lng > lng)) {
                double intersect = (pj.lat - pi.lat) * (lng - pi.lng) / (pj.lng - pi.lng) + pi.lat;
                if (lat < intersect) inside = !inside;
            }
            j = i;
        }
        return inside;
    }

    private boolean isNearPolygonEdge(double lat, double lng, List<LatLng> polygon, double bufferMeters) {
        Distance distance = new Distance();
        LatLng point = new LatLng(lat, lng);

        for (int i = 0; i < polygon.size(); i++) {
            LatLng p1 = polygon.get(i);
            LatLng p2 = polygon.get((i + 1) % polygon.size());
            if (distance.distanceToLine(point, p1, p2) <= bufferMeters) return true;
        }
        return false;
    }

    private NotificationCompat.Builder buildNotification(String contentText) {
        Intent intent = getPackageManager().getLaunchIntentForPackage(getPackageName());
        PendingIntent pendingIntent = PendingIntent.getActivity(
                this, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        return new NotificationCompat.Builder(this, "geofence_channel")
                .setContentTitle("Geofence Service")
                .setContentText(contentText)
                .setSmallIcon(android.R.drawable.ic_dialog_map)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH);
    }

    private void showEventNotification(String title, String body) {
    NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    NotificationCompat.Builder builder = new NotificationCompat.Builder(this, EVENT_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(android.R.drawable.ic_dialog_map)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true);

    manager.notify((int) System.currentTimeMillis(), builder.build()); // unique ID
}


    private void createNotificationChannel() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        NotificationChannel channel = new NotificationChannel(
                "geofence_channel",
                "Geofence Service",
                NotificationManager.IMPORTANCE_HIGH // <-- was LOW
        );
        channel.enableLights(true);
        channel.setLightColor(Color.BLUE);
        channel.enableVibration(true);

        getSystemService(NotificationManager.class).createNotificationChannel(channel);
    }
}


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        fusedLocationClient.removeLocationUpdates(locationCallback);
    }

    // ---------------- Data Classes ----------------

    private static class LatLng {
        double lat;
        double lng;
        LatLng(double lat, double lng) { this.lat = lat; this.lng = lng; }
    }

    private static class Zone {
        String name;
        boolean isOn;
        List<LatLng> points;
        Zone(String name, boolean isOn, List<LatLng> points) {
            this.name = name;
            this.isOn = isOn;
            this.points = points;
        }
    }

    private static class Distance {
        private static final double EARTH_RADIUS = 6371000;

        double distanceToLine(LatLng point, LatLng start, LatLng end) {
            double x0 = point.lat, y0 = point.lng;
            double x1 = start.lat, y1 = start.lng;
            double x2 = end.lat, y2 = end.lng;

            double A = x0 - x1;
            double B = y0 - y1;
            double C = x2 - x1;
            double D = y2 - y1;

            double dot = A * C + B * D;
            double len_sq = C * C + D * D;
            double param = len_sq != 0 ? dot / len_sq : -1;

            double xx, yy;
            if (param < 0) { xx = x1; yy = y1; }
            else if (param > 1) { xx = x2; yy = y2; }
            else { xx = x1 + param * C; yy = y1 + param * D; }

            double dx = x0 - xx;
            double dy = y0 - yy;
            return Math.sqrt(dx * dx + dy * dy) * 111139; // degrees to meters approx
        }
    }
}

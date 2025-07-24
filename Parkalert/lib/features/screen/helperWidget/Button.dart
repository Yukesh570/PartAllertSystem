import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:flutter/material.dart';

Widget buildMainButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
}) {
  final dark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    width: 200, // Adjust width as needed
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0), // More rounded for pill shape
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mainButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // pill-shaped
        ),
        minimumSize: const Size(200, 60), // same size as before
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

// Helper method for circular icon buttons
Widget buildCircularIconButton({
  required BuildContext context,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.mainButtonColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: AppColors.lightTextColor, size: 30),
      onPressed: onPressed,
    ),
  );
}

Widget buildCircularAddbButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.mainButtonColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: AppColors.lightTextColor, size: 30),
      onPressed: onPressed,
    ),
  );
}

// Helper method to build large action buttons
Widget buildConnectButton({
  required String text,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        shadowColor: backgroundColor.withOpacity(0.3),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

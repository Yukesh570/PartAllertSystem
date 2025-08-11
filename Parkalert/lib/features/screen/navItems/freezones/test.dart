import 'package:flutter/material.dart';

class FreeZoneCard extends StatelessWidget {
  final String title;
  final String startTime;
  final String endTime;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final bool isActive;
  final VoidCallback onClose;
  final VoidCallback onAction;
  final VoidCallback onLocation;

  const FreeZoneCard({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    required this.isActive,
    required this.onClose,
    required this.onAction,
    required this.onLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onClose,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: Icon(Icons.close, size: 14, color: Colors.black),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: onLocation,
                child: Icon(
                  Icons.location_on,
                  size: 18,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timeBox(startTime, textColor),
              const SizedBox(width: 6),
              Text(
                "TOT",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(width: 6),
              _timeBox(endTime, textColor),
            ],
          ),
          const SizedBox(height: 8),
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.grey.shade400 : Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String time, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

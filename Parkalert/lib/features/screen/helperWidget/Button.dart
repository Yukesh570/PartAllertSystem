import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:flutter/material.dart';

Widget buildMainButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 120, // Adjust width as needed
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.mainButtonColor,
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
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors
            .transparent, // Make button background transparent to show container color
        foregroundColor: AppColors.lightTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0, // No extra elevation as container has it
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// Helper method for circular icon buttons
Widget buildCircularIconButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: AppColors.buttonBackground,
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

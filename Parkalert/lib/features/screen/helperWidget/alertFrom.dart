import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:flutter/material.dart';

Widget buildAlertFormRow({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  TextEditingController? controller,
}) {
  return Row(
    children: [
      Icon(icon, color: AppColors.iconColor, size: 30),
      const SizedBox(width: 15.0),
      Expanded(
        child: TextField(
          controller: controller,
          readOnly: text == 'Name' ? false : true,
          onTap: onTap,

          decoration: InputDecoration(
            hintText: text,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: AppColors.alertHeaderBackground.withOpacity(0.5),
              ),
            ),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

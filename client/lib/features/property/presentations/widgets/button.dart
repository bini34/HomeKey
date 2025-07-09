import 'package:flutter/material.dart';

Widget appImageUploadButton({
  required VoidCallback onPressed,
  String? labelText,
  String? buttonText,
  IconData? icon,
  bool hasError = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The label that matches the text field hint style
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              labelText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // The button styled like the text field
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            side: BorderSide(color: hasError ? Colors.red : Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            children: [
              Icon(icon ?? Icons.camera_alt),
              const SizedBox(width: 12),
              Text(
                buttonText ?? "Upload Image",
                style: TextStyle(fontFamily: "Inter"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

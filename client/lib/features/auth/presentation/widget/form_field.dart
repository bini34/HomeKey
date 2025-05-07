import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: Theme.of(context).inputDecorationTheme.border,
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

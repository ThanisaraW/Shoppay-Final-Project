import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ShopeeSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool readOnly;
  final TextEditingController? controller;

  const ShopeeSearchBar({
    super.key,
    this.hintText = 'ค้นหาใน Shopee',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          suffixIcon: Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
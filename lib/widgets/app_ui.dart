import 'package:flutter/cupertino.dart';

import '../app_state.dart';

const appBackground = Color(0xFFF4F7FB);
const appInk = Color(0xFF17243A);
const appMuted = Color(0xFF718096);
const appBorder = Color(0xFFE7ECF3);

Color appAccent(BuildContext context) =>
    CupertinoTheme.of(context).primaryColor;

Widget appContent({required Widget child, double maxWidth = 1100}) => Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: child,
  ),
);

Widget appCard({required Widget child, EdgeInsets? padding, Color? color}) =>
    Container(
      padding: padding ?? const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color ?? CupertinoColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: appBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B183155),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

Widget sectionHeading(String eyebrow, String title, {String? subtitle}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            color: appMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.7,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: appInk,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 7),
          Text(subtitle, style: const TextStyle(color: appMuted, fontSize: 14)),
        ],
      ],
    );

Widget iconBadge(IconData icon, Color accent, {double size = 44}) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    color: accent.withValues(alpha: 0.11),
    borderRadius: BorderRadius.circular(size * 0.32),
  ),
  child: Icon(icon, color: accent, size: size * 0.5),
);

Widget productArtwork(Product product, Color accent, {double size = 58}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.25),
      child: product.imageBytes == null
          ? iconBadge(product.icon, accent, size: size)
          : Image.memory(
              product.imageBytes!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
    );

Widget appField({
  required String label,
  required TextEditingController controller,
  required String placeholder,
  TextInputType? keyboardType,
  int maxLines = 1,
  bool obscureText = false,
  Widget? prefix,
  Widget? suffix,
  ValueChanged<String>? onSubmitted,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      label,
      style: const TextStyle(
        color: appInk,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 9),
    CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      prefix: prefix,
      suffix: suffix,
      onSubmitted: onSubmitted,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: appBorder),
      ),
    ),
  ],
);

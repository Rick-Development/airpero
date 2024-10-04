import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../utils/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController? ctrl;
  final double? width;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final String? svgPrefix;
  final String? Function(String?)? validator;
  final bool autoValidate;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool showBorder;
  final TextInputType? keyboardType;
  final VoidCallback? callback;
  final String? trailingSvg;
  final double? radius;
  final Color? color;

  /// By default, this will be a single-line input unless specified
  final int minLines;

  const CustomTextfield({
    Key? key,
    this.ctrl,
    this.width,
    this.label,
    this.hintText,
    this.svgPrefix,
    this.validator,
    this.obscureText = false,
    this.showBorder = true,
    this.autoValidate = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.keyboardType,
    this.callback,
    this.trailingSvg,
    this.radius,
    this.minLines = 1, // Default to 1 to behave like a single-line input
    this.color,
  }) : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool hideText = false;

  @override
  void initState() {
    super.initState();
    hideText = widget.obscureText; // Set initial hide/show state for password
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty ?? false)
          Text(
            widget.label ?? '',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                // fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color(0xFF111111)),
          ),
        const Gap(4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 12),
          ),
          width: widget.width,
          child: TextFormField(
            style: const TextStyle(
              // fontFamily: 'Roboto'
            ),
            minLines: widget.minLines,
            maxLines: widget.obscureText ? 1 : widget.minLines,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            onTap: widget.callback,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            autovalidateMode: widget.autoValidate ? AutovalidateMode.always : null,
            validator: widget.validator,
            controller: widget.ctrl,  // Ensure controller is passed correctly
            obscureText: hideText,
            decoration: InputDecoration(
              suffixIcon: _buildSuffixIcon(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: widget.svgPrefix != null
                  ? Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/svgs/${widget.svgPrefix}.svg',
                ),
              )
                  : null,
              filled: true,
              fillColor: widget.color ?? Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                  color: AppColors.textGreyColor.withOpacity(.2),
                ),
              ),
              enabledBorder: widget.showBorder
                  ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                  color: AppColors.textGreyColor.withOpacity(.2),
                ),
              )
                  : InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.trailingSvg != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          'assets/svgs/${widget.trailingSvg}.svg',
          fit: BoxFit.scaleDown,
        ),
      );
    } else if (widget.obscureText) {
      return InkWell(
        onTap: () {
          setState(() {
            hideText = !hideText;
          });
        },
        child: Icon(
          hideText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textGreyColor,
        ),
      );
    }
    return null;
  }
}

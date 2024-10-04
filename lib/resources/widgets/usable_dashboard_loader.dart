import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/app_colors.dart';

class UsableDashboardLoader extends StatelessWidget {
  const UsableDashboardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(1), // Semi-transparent background
            child: Center(
              child: LoadingAnimationWidget.beat(
                color: AppColors.primaryColor,
                size: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

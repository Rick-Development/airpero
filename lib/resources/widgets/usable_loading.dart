import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:loading_indicator/loading_indicator.dart';
import '../../../../config/app_colors.dart';

class UsableLoading extends StatelessWidget {
  final opacity ;
  const UsableLoading({super.key, this.opacity = 0.9});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: AppColors.mainColor.withOpacity(opacity),  // Semi-transparent background
     body: Container(
        color: AppColors.mainColor.withOpacity(opacity),  // Semi-transparent background
        child: Center(
          child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple, /// Required, The loading type of the widget
              // colors: const [ AppColors.mainColor],       /// Optional, The color collections
              strokeWidth: 1,                     /// Optional, The stroke of the line, only applicable to widget which contains line
              backgroundColor: AppColors.mainColor.withOpacity(opacity),      /// Optional, Background of the widget
              pathBackgroundColor: AppColors.mainColor.withOpacity(opacity)   /// Optional, the stroke backgroundColor
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:async';

import '../utils/app_colors.dart';

class UsableDashboardSlider extends StatefulWidget {
  final List<String> imagePaths;

  const UsableDashboardSlider({
    Key? key,
    required this.imagePaths,
  }) : super(key: key);

  @override
  _UsableDashboardSliderState createState() => _UsableDashboardSliderState();
}

class _UsableDashboardSliderState extends State<UsableDashboardSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < widget.imagePaths.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100, // Fixed height for the slider
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16), // Add border radius
                child: Image.asset(
                  widget.imagePaths[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        const Gap(14),
        // Redesigned Position Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imagePaths.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentIndex == index ? 20.0 : 10.0, // Change size to reflect active state
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: _currentIndex == index
                    ? AppColors.primaryColor
                    : Colors.grey.withOpacity(0.5), // Add transparency for inactive dots
              ),
            );
          }),
        ),
      ],
    );
  }
}

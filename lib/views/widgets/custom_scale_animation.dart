import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FadeInAnimation extends StatelessWidget{
  final Widget widget;
  final int duration;
  final int index;
  const CustomAnimation({super.key, required this.widget, required this.duration,
  required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
        child: AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: duration),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                )
              )
         ),
    );
  }
  

}

class SlideAnimation extends StatelessWidget{
  final Widget widget;
  final int duration;
  final int index;
  const CustomAnimation({super.key, required this.widget, required this.duration,
    required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: duration),
          child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              )
          )
      ),
    );
  }


}


class ScaleAnimation extends StatelessWidget{
  final Widget widget;
  final int duration;
  final int index;
  const CustomAnimation({super.key, required this.widget, required this.duration,
    required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: duration),
          child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              )
          )
      ),
    );
  }


}


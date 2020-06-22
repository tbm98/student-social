import 'package:flutter/material.dart';

class ButtonCurrentDay extends StatelessWidget {
  const ButtonCurrentDay({this.animation, this.onTap, this.currentDay});

  final Animation animation;
  final VoidCallback onTap;
  final String currentDay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, Widget child) {
        return child;
      },
      child: ScaleTransition(
        scale: animation,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FloatingActionButton(
            heroTag: 'button_current_day',
            onPressed: onTap,
            mini: true,
            backgroundColor: Colors.yellow,
            child: Text(
              currentDay,
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}

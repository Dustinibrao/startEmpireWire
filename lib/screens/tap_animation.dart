import 'package:flutter/material.dart';

class TapAnimationWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const TapAnimationWidget({required this.child, required this.onTap});

  @override
  _TapAnimationWidgetState createState() => _TapAnimationWidgetState();
}

class _TapAnimationWidgetState extends State<TapAnimationWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8.0),
        color: _isPressed ? Colors.grey.withOpacity(0.9) : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}

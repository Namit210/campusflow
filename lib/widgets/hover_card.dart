import 'package:flutter/material.dart';

/// Wrap any card with this to get a pointer cursor and a gentle
/// "grow" effect when the mouse hovers over it (Chrome / desktop).
class HoverCard extends StatefulWidget {
  final Widget child;
  final double scale;
  const HoverCard({super.key, required this.child, this.scale = 1.01});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

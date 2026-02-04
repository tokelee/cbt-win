import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class HoverEffect extends StatefulWidget {
  final Widget Function(bool isHovered) builder;

  const HoverEffect({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    
    final hoveredTransform = Matrix4.identity()..translate(0.0,-2.0);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 300),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );
  }

    void onEntered(bool isHovered)=> setState(() {
    this.isHovered = isHovered;
  });
}
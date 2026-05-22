import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResourceBar extends StatelessWidget {
  final String label;
  final int current;
  final int max;
  final Color color;
  final Color bgColor;
  final double height;
  final bool showNumbers;

  const ResourceBar({
    super.key,
    required this.label,
    required this.current,
    required this.max,
    required this.color,
    this.bgColor = const Color(0xFF1A1A2E),
    this.height = 16,
    this.showNumbers = true,
  });

  double get _percent => max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;

  Color get _barColor {
    if (_percent > 0.50) return color;
    if (_percent > 0.25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showNumbers)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              Text('$current / $max',
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        const SizedBox(height: 2),
        Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              widthFactor: _percent,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: _barColor,
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: _barColor.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HpBar extends StatelessWidget {
  final int current;
  final int max;
  const HpBar({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) => ResourceBar(
        label: 'HP',
        current: current,
        max: max,
        color: const Color(0xFF44DD44),
      );
}

class MpBar extends StatelessWidget {
  final int current;
  final int max;
  const MpBar({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) => ResourceBar(
        label: 'MP',
        current: current,
        max: max,
        color: const Color(0xFF4488FF),
      );
}

class SpBar extends StatelessWidget {
  final int current;
  final int max;
  const SpBar({super.key, required this.current, required this.max});

  @override
  Widget build(BuildContext context) => ResourceBar(
        label: 'SP',
        current: current,
        max: max,
        color: const Color(0xFFFFCC44),
      );
}

class XpBar extends StatelessWidget {
  final int current;
  final int max;
  final int level;
  const XpBar(
      {super.key,
      required this.current,
      required this.max,
      required this.level});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text('$current / $max XP',
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 2),
          ResourceBar(
            label: '',
            current: current,
            max: max,
            color: Colors.amber,
            showNumbers: false,
            height: 8,
          ),
        ],
      );
}

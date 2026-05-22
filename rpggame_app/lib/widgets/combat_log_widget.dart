import 'package:flutter/material.dart';
import '../core/game_events.dart';
import '../core/enums.dart';

class CombatLogWidget extends StatefulWidget {
  final List<CombatLogEntry> entries;
  final int maxVisible;

  const CombatLogWidget({
    super.key,
    required this.entries,
    this.maxVisible = 6,
  });

  @override
  State<CombatLogWidget> createState() => _CombatLogWidgetState();
}

class _CombatLogWidgetState extends State<CombatLogWidget> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(CombatLogWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entries.length != oldWidget.entries.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Color _colorForType(LogType type) {
    switch (type) {
      case LogType.combat: return Colors.white;
      case LogType.status: return const Color(0xFFFFAA44);
      case LogType.system: return Colors.cyan;
      case LogType.story: return const Color(0xFFCC88FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.entries.length > widget.maxVisible
        ? widget.entries.sublist(widget.entries.length - widget.maxVisible)
        : widget.entries;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A).withOpacity(0.9),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        controller: _scroll,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        itemCount: visible.length,
        itemBuilder: (ctx, i) {
          final entry = visible[i];
          final isLast = i == visible.length - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              entry.message,
              style: TextStyle(
                color: _colorForType(entry.type)
                    .withOpacity(isLast ? 1.0 : 0.65),
                fontSize: isLast ? 13 : 12,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

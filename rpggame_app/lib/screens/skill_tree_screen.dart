import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/skills/base_skill.dart';
import '../core/enums.dart';
import '../data/skills_data.dart';
import '../data/heroes_data.dart';

class SkillTreeScreen extends StatefulWidget {
  const SkillTreeScreen({super.key});

  @override
  State<SkillTreeScreen> createState() => _SkillTreeScreenState();
}

class _SkillTreeScreenState extends State<SkillTreeScreen> {

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final hero = gp.hero!;

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToStageMap,
        ),
        title: Text('${hero.name}\'s Skills',
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          if (hero.availableStatPoints > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text('${hero.availableStatPoints} pts',
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.amber,
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stat points allocation
          if (hero.availableStatPoints > 0) ...[
            const _SectionHeader('Allocate Stat Points'),
            _StatAllocation(hero: hero, onAllocate: (stat) {
              hero.spendStatPoint(stat);
              setState(() {});
            }),
            const SizedBox(height: 16),
          ],

          // Current skills
          const _SectionHeader('Active Skills'),
          ...hero.skills.map((s) => _SkillTile(skill: s, isOwned: true)),
          const SizedBox(height: 16),

          // Unlockable skills
          const _SectionHeader('Skills to Unlock'),
          ..._getUnlockable(hero).map((s) => _SkillTile(
                skill: s,
                isOwned: false,
                unlockLevel: 5,
                currentLevel: hero.level,
              )),
        ],
      ),
    );
  }

  List<BaseSkill> _getUnlockable(dynamic hero) {
    final unlockIds = HeroesData.levelUpSkills[hero.id] ?? [];
    return unlockIds
        .map((id) => SkillsData.build(id))
        .where((s) => s != null)
        .cast<BaseSkill>()
        .where((s) => !hero.skills.any((owned) => owned.id == s.id))
        .toList();
  }
}

class _StatAllocation extends StatelessWidget {
  final dynamic hero;
  final ValueChanged<String> onAllocate;

  const _StatAllocation({required this.hero, required this.onAllocate});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.06),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _AllocBtn('STR', hero.baseStr, onAllocate),
            _AllocBtn('AGI', hero.baseAgi, onAllocate),
            _AllocBtn('INT', hero.baseInt, onAllocate),
            _AllocBtn('CON', hero.baseCon, onAllocate),
            _AllocBtn('DEF', hero.baseDef, onAllocate),
            _AllocBtn('MDEF', hero.baseMdef, onAllocate),
          ],
        ),
      );
}

class _AllocBtn extends StatelessWidget {
  final String stat;
  final int value;
  final ValueChanged<String> onTap;
  const _AllocBtn(this.stat, this.value, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onTap(stat.toLowerCase()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text('$stat ($value)',
                  style: const TextStyle(
                      color: Colors.amber, fontSize: 12)),
            ],
          ),
        ),
      );
}

class _SkillTile extends StatelessWidget {
  final BaseSkill skill;
  final bool isOwned;
  final int? unlockLevel;
  final int? currentLevel;

  const _SkillTile({
    required this.skill,
    required this.isOwned,
    this.unlockLevel,
    this.currentLevel,
  });

  Color get _typeColor {
    switch (skill.type) {
      case SkillType.physical: return const Color(0xFFCC4444);
      case SkillType.magic: return const Color(0xFF4466FF);
      case SkillType.passive: return const Color(0xFF44AA66);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canUnlock = !isOwned &&
        unlockLevel != null &&
        currentLevel != null &&
        currentLevel! >= unlockLevel!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwned
            ? _typeColor.withOpacity(0.08)
            : Colors.white.withOpacity(0.03),
        border: Border.all(
            color: isOwned
                ? _typeColor.withOpacity(0.5)
                : Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              skill.type == SkillType.magic
                  ? Icons.auto_fix_high
                  : skill.type == SkillType.physical
                      ? Icons.sports_martial_arts
                      : Icons.shield,
              color: _typeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.name,
                    style: TextStyle(
                        color: isOwned ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text(skill.description,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 11),
                    maxLines: 2),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    if (skill.manaCost > 0)
                      Text('${skill.manaCost}MP',
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 10)),
                    if (skill.staminaCost > 0)
                      Text('${skill.staminaCost}SP',
                          style: const TextStyle(
                              color: Colors.amber, fontSize: 10)),
                    if (skill.cooldown > 0)
                      Text('CD:${skill.cooldown}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10)),
                    if (skill.damageMultiplier > 0)
                      Text(
                          '${(skill.damageMultiplier * 100).round()}% dmg',
                          style: TextStyle(
                              color: _typeColor, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          if (isOwned)
            const Icon(Icons.check_circle, color: Colors.green, size: 20)
          else if (unlockLevel != null)
            Column(
              children: [
                Icon(
                  canUnlock ? Icons.lock_open : Icons.lock,
                  color: canUnlock ? Colors.amber : Colors.white24,
                  size: 20,
                ),
                Text('Lv.$unlockLevel',
                    style: TextStyle(
                        color: canUnlock ? Colors.amber : Colors.white24,
                        fontSize: 10)),
              ],
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(title.toUpperCase(),
            style: const TextStyle(
                color: Colors.amber,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
      );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../core/enums.dart';
import '../data/heroes_data.dart';
import '../widgets/health_bar.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  CharacterClass _selected = CharacterClass.warrior;

  static const _classes = [
    CharacterClass.warrior,
    CharacterClass.rogue,
    CharacterClass.mage,
  ];

  static const _icons = [
    Icons.shield,
    Icons.flash_on,
    Icons.auto_fix_high,
  ];

  static const _classNames = ['Brix', 'Lyra', 'Kaelen'];
  static const _classLabels = ['Warrior', 'Rogue', 'Mage'];

  static const _colors = [
    Color(0xFFCC4444),
    Color(0xFF44CCAA),
    Color(0xFF4488FF),
  ];

  @override
  Widget build(BuildContext context) {
    final gp = context.read<GameProvider>();
    final hero = HeroesData.all()[_selected.index];
    final color = _colors[_selected.index];

    return Scaffold(
      backgroundColor: const Color(0xFF080812),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: gp.goToMainMenu,
        ),
        title: const Text('Choose Your Champion',
            style: TextStyle(color: Colors.white70, fontSize: 16)),
      ),
      body: Column(
        children: [
          // Class selector tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_classes.length, (i) {
                final isActive = _selected == _classes[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = _classes[i]),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? _colors[i].withOpacity(0.2)
                            : Colors.white.withOpacity(0.04),
                        border: Border.all(
                            color: isActive
                                ? _colors[i]
                                : Colors.white12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(_icons[i],
                              color: isActive ? _colors[i] : Colors.white38,
                              size: 24),
                          const SizedBox(height: 4),
                          Text(_classLabels[i],
                              style: TextStyle(
                                color: isActive ? _colors[i] : Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Hero name + role
                  Text(
                    _classNames[_selected.index],
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: 4,
                    ),
                  ).animate(key: ValueKey(_selected)).fadeIn().slideY(begin: -0.2),
                  Text(
                    '— ${_classLabels[_selected.index]} —',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.06),
                      border: Border.all(color: color.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      HeroesData.classDescription(_selected),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stat bars
                  _StatBlock(
                    heroIndex: _selected.index,
                    color: color,
                    hp: hero.baseMaxHp,
                    mp: hero.baseMaxMp,
                    sp: hero.baseMaxSp,
                    str: hero.baseStr,
                    agi: hero.baseAgi,
                    intel: hero.baseInt,
                    def: hero.baseDef,
                    crit: hero.baseCritChance,
                    dodge: hero.baseDodgeChance,
                  ),
                  const SizedBox(height: 16),

                  // Skills preview
                  _SkillsPreview(hero: hero, color: color),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Select button
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => gp.selectHero(_selected),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'BEGIN WITH ${_classNames[_selected.index].toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final int heroIndex, hp, mp, sp, str, agi, intel, def;
  final double crit, dodge;
  final Color color;

  const _StatBlock({
    required this.heroIndex,
    required this.hp,
    required this.mp,
    required this.sp,
    required this.str,
    required this.agi,
    required this.intel,
    required this.def,
    required this.crit,
    required this.dodge,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ResourceBar(label: 'HP', current: hp, max: hp, color: Colors.green),
          const SizedBox(height: 6),
          ResourceBar(label: 'MP', current: mp, max: mp, color: Colors.blue),
          const SizedBox(height: 6),
          ResourceBar(label: 'SP', current: sp, max: sp, color: Colors.amber),
          const SizedBox(height: 10),
          Row(
            children: [
              _Stat('STR', str, color),
              _Stat('AGI', agi, color),
              _Stat('INT', intel, color),
              _Stat('DEF', def, color),
              _Stat('CRIT', '${(crit * 100).round()}%', color),
              _Stat('DODGE', '${(dodge * 100).round()}%', color),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final dynamic value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text('$value',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      );
}

class _SkillsPreview extends StatelessWidget {
  final dynamic hero;
  final Color color;
  const _SkillsPreview({required this.hero, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Starting Skills',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...hero.skills.map<Widget>((s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: color, size: 14),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name,
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        Text(s.description,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

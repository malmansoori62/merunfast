import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../core/enums.dart';
import '../models/character/enemy.dart';
import '../models/character/boss.dart';
import '../models/items/consumable.dart';
import '../widgets/health_bar.dart';
import '../widgets/skill_button.dart';
import '../widgets/combat_log_widget.dart';
import '../widgets/status_badge.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  Timer? _enemyTimer;

  @override
  void dispose() {
    _enemyTimer?.cancel();
    super.dispose();
  }

  void _scheduleEnemyTurn(GameProvider gp) {
    _enemyTimer?.cancel();
    _enemyTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      gp.triggerEnemyTurn();
      // Chain enemy turns if still enemy turn
      if (gp.combat.state == CombatState.enemyTurn) {
        _scheduleEnemyTurn(gp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();
    final combat = gp.combat;
    final hero = gp.hero!;
    final enemies = combat.enemies;

    // Trigger enemy turn
    if (combat.state == CombatState.enemyTurn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scheduleEnemyTurn(gp);
      });
    }

    final isPlayerTurn = combat.isPlayerTurn;
    final isBoss = enemies.any((e) => e is Boss);

    return WillPopScope(
      onWillPop: () async {
        _showPauseMenu(context, gp);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF080812),
        body: SafeArea(
          child: Column(
            children: [
              // ── Top bar ─────────────────────────────────────────────────
              _TopBar(gp: gp, isBoss: isBoss),
              const Divider(color: Colors.white12, height: 1),
              Expanded(
                child: Column(
                  children: [
                    // ── Enemies ────────────────────────────────────────────
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: enemies.isEmpty
                            ? const Center(
                                child: Text('No enemies',
                                    style: TextStyle(color: Colors.white38)))
                            : ListView.separated(
                                itemCount: enemies.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (_, i) =>
                                    _EnemyCard(enemy: enemies[i], isBoss: isBoss),
                              ),
                      ),
                    ),
                    // ── Combat log ─────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: 110,
                        child: CombatLogWidget(entries: combat.combatLog),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Hero status ────────────────────────────────────────
                    _HeroStatus(hero: hero),
                    const SizedBox(height: 8),
                    // ── Action buttons ─────────────────────────────────────
                    if (isPlayerTurn) _ActionPanel(gp: gp, hero: hero),
                    if (!isPlayerTurn && !combat.isOver)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white38)),
                            SizedBox(width: 12),
                            Text('Enemy is acting...',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPauseMenu(BuildContext ctx, GameProvider gp) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF1A1A2E),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PAUSED',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.amber),
              title: const Text('Resume', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('Flee to Map',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                gp.doEscape();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Settings',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                gp.goToSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final GameProvider gp;
  final bool isBoss;
  const _TopBar({required this.gp, required this.isBoss});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (isBoss)
              const Text('⚠️ BOSS BATTLE',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            if (!isBoss)
              Text(gp.stage.progressLabel,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12)),
            const Spacer(),
            Text('Round ${gp.combat.round}',
                style: const TextStyle(color: Colors.amber, fontSize: 12)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Icon(Icons.menu, color: Colors.white38, size: 22),
            ),
          ],
        ),
      );
}

class _EnemyCard extends StatelessWidget {
  final Enemy enemy;
  final bool isBoss;
  const _EnemyCard({required this.enemy, required this.isBoss});

  Color get _typeColor {
    if (enemy is Boss) return Colors.red;
    switch (enemy.aiBehavior) {
      case AIBehavior.aggressive: return Colors.orange;
      case AIBehavior.defensive: return Colors.blue;
      case AIBehavior.tactical: return Colors.purple;
      case AIBehavior.berserker: return Colors.red;
      case AIBehavior.support: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hpPercent =
        enemy.maxHp > 0 ? enemy.currentHp / enemy.maxHp : 0.0;
    return AnimatedOpacity(
      duration: 300.ms,
      opacity: enemy.isAlive ? 1.0 : 0.3,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _typeColor.withOpacity(0.06),
          border: Border.all(color: _typeColor.withOpacity(enemy.isAlive ? 0.5 : 0.15)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  enemy is Boss ? Icons.warning_amber : Icons.person,
                  color: _typeColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  enemy.name,
                  style: TextStyle(
                      color: _typeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${enemy.currentHp}/${enemy.maxHp} HP',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                ),
                if (enemy is Boss)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      (enemy as Boss).phase == BossPhase.phase2
                          ? '⚡ PHASE 2'
                          : 'PHASE 1',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: hpPercent.clamp(0.0, 1.0),
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(
                hpPercent > 0.5
                    ? Colors.green
                    : hpPercent > 0.25
                        ? Colors.orange
                        : Colors.red,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            if (enemy.activeEffects.isNotEmpty) ...[
              const SizedBox(height: 6),
              StatusBadgeRow(effects: enemy.activeEffects),
            ],
            if (!enemy.isAlive) ...[
              const SizedBox(height: 4),
              const Text('☠️ Defeated',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroStatus extends StatelessWidget {
  final dynamic hero;
  const _HeroStatus({required this.hero});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(hero.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(width: 8),
                Text('Lv.${hero.level}',
                    style: const TextStyle(
                        color: Colors.amber, fontSize: 12)),
                const Spacer(),
                Text('💰 ${hero.gold}g',
                    style: const TextStyle(
                        color: Colors.amber, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            HpBar(current: hero.currentHp, max: hero.maxHp),
            const SizedBox(height: 4),
            MpBar(current: hero.currentMp, max: hero.maxMp),
            const SizedBox(height: 4),
            SpBar(current: hero.currentSp, max: hero.maxSp),
            if (hero.activeEffects.isNotEmpty) ...[
              const SizedBox(height: 6),
              StatusBadgeRow(effects: hero.activeEffects),
            ],
          ],
        ),
      );
}

class _ActionPanel extends StatefulWidget {
  final GameProvider gp;
  final dynamic hero;
  const _ActionPanel({required this.gp, required this.hero});

  @override
  State<_ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends State<_ActionPanel> {
  int _tab = 0; // 0=actions, 1=skills, 2=items

  @override
  Widget build(BuildContext context) {
    final gp = widget.gp;
    final hero = widget.hero;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Tab row
          Row(
            children: [
              _Tab(label: 'ACTIONS', active: _tab == 0, onTap: () => setState(() => _tab = 0)),
              _Tab(label: 'SKILLS', active: _tab == 1, onTap: () => setState(() => _tab = 1)),
              _Tab(label: 'ITEMS', active: _tab == 2, onTap: () => setState(() => _tab = 2)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _tab == 0
                ? _BasicActions(gp: gp)
                : _tab == 1
                    ? _SkillsPanel(gp: gp, hero: hero)
                    : _ItemsPanel(gp: gp),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? Colors.amber : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: active ? Colors.amber : Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          ),
        ),
      );
}

class _BasicActions extends StatelessWidget {
  final GameProvider gp;
  const _BasicActions({required this.gp});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: _ActionBtn(
                  label: 'ATTACK',
                  icon: Icons.gavel,
                  color: Colors.orange,
                  onTap: gp.doAttack)),
          const SizedBox(width: 8),
          Expanded(
              child: _ActionBtn(
                  label: 'DEFEND',
                  icon: Icons.shield,
                  color: Colors.blue,
                  onTap: gp.doDefend)),
          const SizedBox(width: 8),
          Expanded(
              child: _ActionBtn(
                  label: 'FLEE',
                  icon: Icons.directions_run,
                  color: Colors.grey,
                  onTap: gp.doEscape)),
        ],
      );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
}

class _SkillsPanel extends StatelessWidget {
  final GameProvider gp;
  final dynamic hero;
  const _SkillsPanel({required this.gp, required this.hero});

  @override
  Widget build(BuildContext context) {
    if (hero.skills.isEmpty) {
      return const Text('No skills',
          style: TextStyle(color: Colors.white38, fontSize: 13));
    }
    return Column(
      children: hero.skills
          .asMap()
          .entries
          .map<Widget>((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SkillButton(
                  skill: e.value,
                  index: e.key,
                  isEnabled: e.value.canUse(
                    currentMana: hero.currentMp,
                    currentStamina: hero.currentSp,
                    isSilenced: hero.isSilenced,
                    isExhausted: hero.isExhausted,
                  ),
                  onTap: () => gp.doSkill(e.key),
                ),
              ))
          .toList(),
    );
  }
}

class _ItemsPanel extends StatelessWidget {
  final GameProvider gp;
  const _ItemsPanel({required this.gp});

  @override
  Widget build(BuildContext context) {
    final consumables = gp.inventory.consumables;
    if (consumables.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('No items',
            style: TextStyle(color: Colors.white38, fontSize: 13)),
      );
    }
    return Column(
      children: consumables
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () => gp.doUseItem(c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      border: Border.all(color: Colors.green.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_pharmacy,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('${c.name} (x${c.quantity})',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ),
                        Text(c.effectLabel,
                            style: const TextStyle(
                                color: Colors.lightGreenAccent,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

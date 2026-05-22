import '../core/enums.dart';
import '../models/character/enemy.dart';
import '../models/character/boss.dart';
import 'enemies_data.dart';

class StageEncounter {
  final List<Enemy> enemies;
  final bool isBossEncounter;
  final String narration;

  const StageEncounter({
    required this.enemies,
    this.isBossEncounter = false,
    required this.narration,
  });
}

class StageData {
  final StageArea area;
  final String name;
  final String subtitle;
  final String description;
  final List<StageEncounter> encounters;
  final Boss boss;
  final int requiredLevel;

  const StageData({
    required this.area,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.encounters,
    required this.boss,
    required this.requiredLevel,
  });
}

class StagsesData {
  StagsesData._();

  static StageData ironholdMines() => StageData(
        area: StageArea.ironholdMines,
        name: 'Ironhold Mines',
        subtitle: 'The Pit of Broken Souls',
        description:
            'Deep beneath the city, condemned prisoners fight for survival in the '
            'iron-choked tunnels. The air reeks of blood and rust. Your rebellion begins here.',
        requiredLevel: 1,
        encounters: [
          StageEncounter(
            enemies: [EnemiesData.mineGladiator()],
            narration:
                'The iron gate groans open. A scarred gladiator charges from the darkness.',
          ),
          StageEncounter(
            enemies: [EnemiesData.cageWolf(), EnemiesData.cageWolf()],
            narration:
                'Growling echoes through the tunnel. Two wolves — starved and vicious — have been released.',
          ),
          StageEncounter(
            enemies: [EnemiesData.shackledMage()],
            narration:
                'Arcane light flickers. A mage, chains broken, unleashes restrained fury on the nearest target — you.',
          ),
          StageEncounter(
            enemies: [EnemiesData.mineGladiator(), EnemiesData.cageWolf()],
            narration:
                'Two guards block the exit. They will not let you pass without a fight.',
          ),
        ],
        boss: EnemiesData.overseerSark(),
      );

  static StageData redSandColosseum() => StageData(
        area: StageArea.redSandColosseum,
        name: 'Red Sand Colosseum',
        subtitle: 'Where Champions Bleed',
        description:
            'The crowd roars. Fifty thousand spectators watch the crimson arena. '
            'You must fight champions trained since birth. This is where legends are forged — or broken.',
        requiredLevel: 5,
        encounters: [
          StageEncounter(
            enemies: [EnemiesData.arenaAssassin()],
            narration:
                'The crowd hushes as a hooded figure sprints across the red sand toward you.',
          ),
          StageEncounter(
            enemies: [EnemiesData.colossumTank()],
            narration:
                'The gates open with a thunderous boom. A titan in iron armor steps into the arena.',
          ),
          StageEncounter(
            enemies: [EnemiesData.berserker()],
            narration:
                'He enters screaming — veins bulging, axes spinning. The crowd goes wild.',
          ),
          StageEncounter(
            enemies: [EnemiesData.arenaAssassin(), EnemiesData.berserker()],
            narration:
                'Two champions at once. The empire wants a spectacle. Give it to them.',
          ),
        ],
        boss: EnemiesData.commanderValerus(),
      );

  static StageData imperialShadowArena() => StageData(
        area: StageArea.imperialShadowArena,
        name: 'Imperial Shadow Arena',
        subtitle: 'The Final Darkness',
        description:
            'Beyond the colosseum lies the secret arena where the Empire conducts its darkest experiments. '
            'Here, death magic and steel collide. Only the Shadow Sovereign awaits you at the end.',
        requiredLevel: 10,
        encounters: [
          StageEncounter(
            enemies: [EnemiesData.shadowNecromancer()],
            narration:
                'Shadow tendrils writhe across the floor as a necromancer rises, draped in stolen life force.',
          ),
          StageEncounter(
            enemies: [EnemiesData.imperialGuard(), EnemiesData.imperialGuard()],
            narration:
                'Two imperial elites in gleaming black plate. They answer only to Malakor.',
          ),
          StageEncounter(
            enemies: [EnemiesData.shadowNecromancer(), EnemiesData.imperialGuard()],
            narration:
                'The darkness grows thick. A guard and his shadow-mage captain stand between you and the throne.',
          ),
        ],
        boss: EnemiesData.malakor(),
      );

  static List<StageData> allStages() => [
        ironholdMines(),
        redSandColosseum(),
        imperialShadowArena(),
      ];
}

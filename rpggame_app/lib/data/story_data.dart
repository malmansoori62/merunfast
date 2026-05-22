import '../core/enums.dart';

class StoryLine {
  final String speaker;
  final String text;
  const StoryLine({required this.speaker, required this.text});
}

class StoryData {
  StoryData._();

  // ── Opening narration ─────────────────────────────────────────────────────

  static const List<StoryLine> opening = [
    StoryLine(
      speaker: 'Narrator',
      text:
          'The Empire of Kethara rules through fear and blood. '
          'Its arenas serve one purpose: to crush the spirit of its people '
          'by reminding them that even the strongest can be broken.',
    ),
    StoryLine(
      speaker: 'Narrator',
      text:
          'You were not born a gladiator. You were taken. '
          'Stripped of your name, your freedom, your life. '
          'But they could not strip you of your will.',
    ),
    StoryLine(
      speaker: 'Narrator',
      text:
          'Today, in the depths of the Ironhold Mines, you pick up a weapon. '
          'Not to entertain the Empire — but to destroy it.',
    ),
  ];

  // ── Stage narrations ──────────────────────────────────────────────────────

  static const Map<StageArea, List<StoryLine>> stageIntros = {
    StageArea.ironholdMines: [
      StoryLine(
        speaker: 'Arena Announcer',
        text: 'Welcome to the Ironhold Mines — where convicts earn their graves!',
      ),
      StoryLine(
        speaker: 'Narrator',
        text:
            'The tunnels smell of iron and despair. Flickering torches cast '
            'long shadows over broken men. You must survive this pit to see daylight.',
      ),
    ],
    StageArea.redSandColosseum: [
      StoryLine(
        speaker: 'Arena Announcer',
        text:
            'Citizens of Kethara! Welcome to the Red Sand Colosseum! '
            'Tonight, a new challenger has risen from the mines. '
            'Let us see if this rabble can survive our champions!',
      ),
      StoryLine(
        speaker: 'Narrator',
        text:
            'The sun blazes over fifty thousand screaming spectators. '
            'The sand beneath your feet is red — not from dye. '
            'Every champion here has killed dozens. You must kill more.',
      ),
    ],
    StageArea.imperialShadowArena: [
      StoryLine(
        speaker: 'Imperial Herald',
        text:
            'By order of the Shadow Sovereign Malakor, '
            'this gladiator has been selected for the final honor — '
            'death in the Imperial Shadow Arena.',
      ),
      StoryLine(
        speaker: 'Narrator',
        text:
            'No crowd. No light. Only shadow, shadow magic, and the distant sound '
            'of something vast stirring in the darkness ahead.',
      ),
    ],
  };

  // ── Boss introductions ────────────────────────────────────────────────────

  static const Map<String, List<StoryLine>> bossIntros = {
    'boss_sark': [
      StoryLine(
        speaker: 'Arena Announcer',
        text: 'And now — the Overseer of Ironhold! The man who has broken '
            'one thousand gladiators — OVERSEER SARK!',
      ),
    ],
    'boss_valerus': [
      StoryLine(
        speaker: 'Arena Announcer',
        text:
            'The moment you\'ve been waiting for! Commander of the Imperial Legion, '
            'undefeated in three hundred bouts — COMMANDER VALERUS!',
      ),
    ],
    'boss_malakor': [
      StoryLine(
        speaker: 'Narrator',
        text:
            'The arena goes completely silent. The torches dim. '
            'A figure materializes from the shadows — '
            'surrounded by crackling void energy, ancient beyond measure.',
      ),
      StoryLine(
        speaker: 'Malakor',
        text:
            'At last... I have watched your little rebellion with great amusement. '
            'Now come. Let me show you true power.',
      ),
    ],
  };

  // ── Victory narrations ────────────────────────────────────────────────────

  static const Map<StageArea, String> stageVictory = {
    StageArea.ironholdMines:
        'The overseer falls. His keys spill across the bloodied ground. '
        'Word will spread through the mines tonight — a gladiator has defied the Empire.',
    StageArea.redSandColosseum:
        'Commander Valerus drops to his knees. The crowd erupts — half in horror, '
        'half in awe. For the first time in a century, the Empire\'s champion is dead.',
    StageArea.imperialShadowArena:
        'Malakor\'s form disperses like smoke. The shadow arena crumbles. '
        'Light floods in for the first time in decades. '
        'The Empire of Kethara is over. You are free.',
  };

  // ── Shop keeper dialogue ──────────────────────────────────────────────────

  static const List<String> shopGreetings = [
    'Aye, what does a gladiator need today?',
    'Blood money spends the same as any. What\'ll you have?',
    'Survive long enough and I\'ll give you a discount. What do you need?',
    'Good fights today. Here to spend your winnings?',
  ];

  // ── Rest area dialogue ────────────────────────────────────────────────────

  static const List<String> restDialogue = [
    'They say the mines break men\'s souls. Yours seems intact — for now.',
    'A wise gladiator rests when they can. Strength is not infinite.',
    'I\'ve seen stronger fall before the boss. Don\'t get cocky.',
    'The crowd cheers for you today. Tomorrow, they cheer for your killer.',
  ];

  static String announcerWin() =>
      'Incredible! The challenger stands! The arena shakes with applause!';

  static String announcerLoss() =>
      'And that is the end of another hopeful. Take them away!';
}

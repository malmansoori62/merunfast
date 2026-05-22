import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/main_menu_screen.dart';
import 'screens/character_selection_screen.dart';
import 'screens/stage_map_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/victory_screen.dart';
import 'screens/defeat_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/equipment_screen.dart';
import 'screens/skill_tree_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF080812),
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider()..loadSettings(),
      child: const GladiatorApp(),
    ),
  );
}

class GladiatorApp extends StatelessWidget {
  const GladiatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gladiator Uprising',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080812),
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Color(0xFFCC4444),
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF080812),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white54),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    final screen = context.watch<GameProvider>().screen;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _buildScreen(screen),
    );
  }

  Widget _buildScreen(GameScreen screen) {
    switch (screen) {
      case GameScreen.mainMenu:
        return const MainMenuScreen();
      case GameScreen.characterSelect:
        return const CharacterSelectionScreen();
      case GameScreen.stageMap:
        return const StageMapScreen();
      case GameScreen.battle:
        return const BattleScreen();
      case GameScreen.victory:
        return const VictoryScreen();
      case GameScreen.defeat:
        return const DefeatScreen();
      case GameScreen.inventory:
        return const InventoryScreen();
      case GameScreen.equipment:
        return const EquipmentScreen();
      case GameScreen.skillTree:
        return const SkillTreeScreen();
      case GameScreen.shop:
        return const ShopScreen();
      case GameScreen.settings:
        return const SettingsScreen();
    }
  }
}

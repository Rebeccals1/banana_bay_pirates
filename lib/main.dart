import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'banana_bay_pirates.dart';
import 'ui/start_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BananaBayPirates _game;
  bool _isGameRunning = false;

  @override
  void initState() {
    super.initState();
    _game = BananaBayPirates();
  }

  void _startGame() {
    setState(() {
      _isGameRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            if (_isGameRunning) GameWidget(game: kDebugMode ? BananaBayPirates() : _game),
            if (!_isGameRunning) StartMenu(onStart: _startGame),
          ],
        ),
      ),
    );
  }
}
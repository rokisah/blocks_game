import 'package:blocks_game/app-state-observer.dart';
import 'package:blocks_game/blocks-game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  Flame.images.loadAll([
    'blocks/block_black.png',
    'blocks/block_blue_black.png',
    'blocks/block_red.png',
    'blocks/block_blue_red.png',
    'blocks/red.png',
    'blocks/blue.png',
    'blocks/green.png',
    'blocks/orange.png',
    'blocks/yellow.png',
  ]);

  SharedPreferences storage = await SharedPreferences.getInstance();
  BlocksGame game = BlocksGame(storage);

  runApp(game.widget);
  WidgetsBinding.instance.addObserver(AppStateObserver());

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;

  flameUtil.addGestureRecognizer(tapper);
}



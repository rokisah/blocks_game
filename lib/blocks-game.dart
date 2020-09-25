import 'dart:ui';

import 'package:blocks_game/view.dart';
import 'package:blocks_game/views/start-view.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocksGame extends Game with TapDetector, VerticalDragDetector {
  Size screenSize;
  double tileSize;
  final SharedPreferences storage;
  View currentView;
  int currentLevel = 1;

  BlocksGame(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // this.currentView = GameView(this);
    this.currentView = StartView(this);
  }

  void render(Canvas canvas) {
    currentView.render(canvas);
  }

  void update(double t) {
    currentView.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = size.width / 9;
    if (currentView != null) {
      currentView.resize(size);
    }
  }

  void onTapDown(TapDownDetails details) {
    currentView.onTapDown(details);
  }

  void onVerticalDragStart(DragStartDetails details) {
    currentView.onVerticalDragStart(details);
  }

  void onVerticalDragEnd(DragEndDetails details) {
    currentView.onVerticalDragEnd(details);
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    currentView.onVerticalDragUpdate(details);
  }

}

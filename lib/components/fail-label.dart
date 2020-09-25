import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/view.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

class FailLabel extends View {

  int imgIndex = 0;
  Rect rect;
  Sprite sprite;

  FailLabel(BlocksGame game) : super(game) {
    rect = Rect.fromLTWH(
        game.tileSize * 1.5,
        (game.tileSize * 4.5),
        game.tileSize * 6,
        game.tileSize * 3);
    sprite = Sprite('ui/fail.png');
  }

  void onTapDown(TapDownDetails details) {}

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void resize(Size size) {}

  void update(double t) {}

  void onVerticalDragEnd(DragEndDetails details) {
      
  }
  
  void onVerticalDragStart(DragStartDetails details) {
      
  }
  
  void onVerticalDragUpdate(DragUpdateDetails details) {
    
  }
  
}

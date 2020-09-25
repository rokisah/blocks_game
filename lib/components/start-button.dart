import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/view.dart';
import 'package:blocks_game/views/game-view.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

class StartButton extends View {
  Rect rect;
  Sprite sprite;

  StartButton(BlocksGame game) : super(game) {
    rect = Rect.fromLTWH(
        game.tileSize * 1.5,
        (game.screenSize.height * .75) - (game.tileSize),
        game.tileSize * 6,
        game.tileSize * 3);
    sprite = Sprite('ui/start-button.png');
  }

  void onTapDown(TapDownDetails details) {
    if (rect.contains(details.globalPosition)) {
      game.currentView = GameView(this.game);
    }
  }

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

import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/components/start-button.dart';
import 'package:blocks_game/view.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

class StartView extends View {
  Rect titleRect;
  Sprite titleSprite;
  int switchInterval = 1000;
  int nextSpawn;
  int imgIndex = 0;
  StartButton startButton;

  StartView(BlocksGame game) : super(game) {
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 3) - (game.tileSize * 4),
      game.tileSize * 7,
      game.tileSize * 4,
    );
    titleSprite = Sprite('branding/title.png');
    nextSpawn = DateTime.now().millisecondsSinceEpoch + switchInterval;
    startButton = StartButton(game);
  }

  void onTapDown(TapDownDetails details) {
    startButton.onTapDown(details);
  }

  void render(Canvas canvas) {
    titleSprite.renderRect(canvas, titleRect);
    startButton.render(canvas);
  }

  void resize(Size size) {}

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp >= nextSpawn) {
      if (imgIndex == 0) {
        titleSprite = Sprite('branding/title2.png');
        imgIndex = 1;
      } else {
        titleSprite = Sprite('branding/title.png');
        imgIndex = 0;
      }
      nextSpawn = nowTimestamp + switchInterval;
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    
  }

  void onVerticalDragStart(DragStartDetails details) {
    
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
  
  }

}
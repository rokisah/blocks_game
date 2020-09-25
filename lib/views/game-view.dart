import 'dart:math';
import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/components/block.dart';
import 'package:blocks_game/components/fail-label.dart';
import 'package:blocks_game/components/score-view.dart';
import 'package:blocks_game/components/start-button.dart';
import 'package:blocks_game/components/success-label.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:blocks_game/enums/game-state-enum.dart';
import 'package:blocks_game/utils/block-util.dart';
import 'package:blocks_game/view.dart';
import 'package:flutter/gestures.dart';
import 'package:blocks_game/game-controller.dart' as GameController;

class GameView extends View {
  List<Block> blocks;
  ScoreView scoreView;
  Random rnd;
  bool isHandled = false;
  bool isDragHandled = false;
  Block selected;
  Block previousSelected;
  bool hasMatches = false;
  bool hasMoved = false;
  SuccessLabel success;
  FailLabel fail;
  StartButton startButton;
  GameStateEnum gameState;

  GameView(BlocksGame game) : super(game) {
    initialize();
  }

  void initialize() async {
    gameState = GameStateEnum.RUNNING;
    rnd = Random();
    blocks = new List();
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 7; x++) {
        ContentEnum content;
        do {
          int idx = rnd.nextInt(5);
          content = BlockUtil.getContent(idx);
        } while (GameController.hasMatches(x, y, blocks, content));
        blocks.add(Block(this, x, y, content));
      }
    }
    scoreView = ScoreView(game);
    success = SuccessLabel(game);
    fail = FailLabel(game);
    startButton = StartButton(game);
  }

  void onTapDown(TapDownDetails details) {
    print("Tap Down");
    switch (gameState) {
      case GameStateEnum.RUNNING:
        blocks.forEach((block) {
          if (block.rect.contains(details.globalPosition)) {
            isHandled = true;
            block.onTapDown();
            GameController.processSelection(this);
            return;
          }
        });
        break;
      case GameStateEnum.WON:
      case GameStateEnum.LOST:
        startButton.onTapDown(details);
        break;
      default:
    }
  }

  void render(Canvas canvas) {
    blocks.forEach((block) => block.render(canvas));
    scoreView.render(canvas);
    if (gameState == GameStateEnum.WON) {
      success.render(canvas);
      startButton.render(canvas);
    } else if (gameState == GameStateEnum.LOST) {
      fail.render(canvas);
      startButton.render(canvas);
    }
  }

  void resize(Size size) {}

  void update(double t) {
    blocks.forEach((block) => block.update(t));
    scoreView.update(t);
  }

  void onVerticalDragStart(DragStartDetails details) {
    print("Start Drag");
    if (gameState == GameStateEnum.RUNNING) {
      selected = null;
      previousSelected = null;
      blocks.forEach((block) {
        if (block.rect.contains(details.globalPosition)) {
          isHandled = true;
          block.onTapDown();
          GameController.processSelection(this);
          return;
        }
      });
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    print("End Drag");
    isDragHandled = false;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    print("Update Drag");
    if (isDragHandled) {
      return;
    }
    if (gameState == GameStateEnum.RUNNING) {
      blocks.forEach((block) {
        if (block != selected && block.rect.contains(details.globalPosition)) {
          isHandled = true;
          isDragHandled = true;
          block.onTapDown();
          GameController.processSelection(this);
          return;
        }
      });
    }
  }
}

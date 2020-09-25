import 'dart:collection';

import 'package:blocks_game/components/block.dart';
import 'package:blocks_game/components/content.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:blocks_game/enums/game-state-enum.dart';
import 'package:blocks_game/utils/block-util.dart';
import 'package:blocks_game/views/game-view.dart';

Future<void> processSelection(GameView gameView) async {
  if (gameView.previousSelected == null) {
    return;
  }
  if (gameView.previousSelected == gameView.selected) {
    gameView.selected = null;
    gameView.previousSelected = null;
  }
  if (gameView.previousSelected != null &&
      gameView.selected != null &&
      (((gameView.previousSelected.x - gameView.selected.x).abs() == 1 &&
              gameView.previousSelected.y - gameView.selected.y == 0) ||
          ((gameView.previousSelected.y - gameView.selected.y).abs() == 1 &&
              gameView.previousSelected.x - gameView.selected.x == 0))) {
    await switchContent(gameView.selected, gameView.previousSelected);
    gameView.hasMoved = false;
    await process(gameView);
    if (gameView.hasMoved) {
      gameView.scoreView.moves--;
      if (gameView.scoreView.targetAchieved) {
        gameView.gameState = GameStateEnum.WON;
        gameView.game.currentLevel++;
      } else if (gameView.scoreView.moves < 1) {
        gameView.gameState = GameStateEnum.LOST;
        gameView.game.currentLevel = 1;
      }
    } else {
      await switchContent(gameView.previousSelected, gameView.selected);
    }
    gameView.selected = null;
    gameView.previousSelected = null;
  } else {
    gameView.previousSelected = null;
  }
}

Future<void> process(GameView gameView) async {
  findRowMatches(gameView);
  findColumnsMatches(gameView);
  if (gameView.hasMatches) {
    gameView.hasMoved = true;
    gameView.blocks.forEach((block) {
      if (block.isMatch) {
        gameView.scoreView.score(block.content);
        block.content = null;
        block.isMatch = false;
      }
    });
    await dropBlocks(gameView);
    await fillGaps(gameView);
    gameView.hasMatches = false;
    await process(gameView);
  }
}

Future<void> switchContent(Block origin, Block destination) async {
  if (origin == null || origin.content == null) {
    return;
  }
  Content selectedContent = origin.content;
  Content previousSelectedContent = destination.content;
  origin.content = previousSelectedContent;
  destination.content = selectedContent;
  while ((origin.content != null && origin.content.isMoving) ||
      (destination.content != null && destination.content.isMoving)) {
    await Future.delayed(Duration(milliseconds: 500));
  }
}

void findRowMatches(GameView gameView) {
  for (int y = 0; y < 10; y++) {
    ContentEnum previous;
    List<Block> matches = List();
    for (int x = 0; x < 7; x++) {
      int idx = BlockUtil.getIndex(x, y);
      if (previous != null &&
          gameView.blocks[idx].content != null &&
          previous == gameView.blocks[idx].content.content) {
        matches.add(gameView.blocks[idx]);
      } else {
        if (matches.length > 4) {
          print("Row >5 - " +
              matches[0].content.content.toString() +
              " - " +
              matches.length.toString());
          ContentEnum color = matches[0].content.content;
          gameView.blocks.forEach((block) {
            if (block.content.content == color) {
              block.isMatch = true;
            }
          });
          gameView.hasMatches = true;
        } else if (matches.length > 2) {
          print("Row >2 - " +
              matches[0].content.content.toString() +
              " - " +
              matches.length.toString());
          matches.forEach((block) => block.isMatch = true);
          gameView.hasMatches = true;
        }
        matches.clear();
        previous = gameView.blocks[idx].content == null
            ? null
            : gameView.blocks[idx].content.content;
        matches.add(gameView.blocks[idx]);
      }
      if (x == 6 && matches.length > 2) {
        matches.forEach((block) => block.isMatch = true);
        gameView.hasMatches = true;
      }
    }
  }
}

void findColumnsMatches(GameView gameView) {
  for (int x = 0; x < 7; x++) {
    ContentEnum previous;
    List<Block> matches = List();
    for (int y = 0; y < 10; y++) {
      int idx = BlockUtil.getIndex(x, y);
      if (previous != null &&
          gameView.blocks[idx].content != null &&
          previous == gameView.blocks[idx].content.content) {
        matches.add(gameView.blocks[idx]);
      } else {
        if (matches.length > 4) {
          print("Col >5 - " +
              matches[0].content.content.toString() +
              " - " +
              matches.length.toString());
          ContentEnum color = matches[0].content.content;
          gameView.blocks.forEach((block) {
            if (block.content.content == color) {
              block.isMatch = true;
            }
          });
          gameView.hasMatches = true;
        } else if (matches.length > 2) {
          print("Col >2 - " +
              matches[0].content.content.toString() +
              " - " +
              matches.length.toString());
          matches.forEach((block) => block.isMatch = true);
          gameView.hasMatches = true;
        }
        matches.clear();
        previous = gameView.blocks[idx].content == null
            ? null
            : gameView.blocks[idx].content.content;
        matches.add(gameView.blocks[idx]);
      }
      if (y == 9 && matches.length > 2) {
        matches.forEach((block) => block.isMatch = true);
        gameView.hasMatches = true;
      }
    }
  }
}

Future<void> dropBlocks(GameView gameView) async {
  for (int x = 0; x < 7; x++) {
    Queue<Block> destinations = Queue();
    for (int y = 9; y >= 0; y--) {
      int idx = BlockUtil.getIndex(x, y);
      if (gameView.blocks[idx].content == null) {
        destinations.add(gameView.blocks[idx]);
      } else {
        if (destinations.isNotEmpty) {
          switchContent(gameView.blocks[idx], destinations.removeFirst());
          destinations.add(gameView.blocks[idx]);
        }
      }
    }
  }
  for (Block block in gameView.blocks) {
    while (block.content != null && block.content.isMoving) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}

Future<void> fillGaps(GameView gameView) async {
  List<Block> destinations = List();
  for (int x = 0; x < 7; x++) {
    for (int y = 9; y >= 0; y--) {
      int idx = BlockUtil.getIndex(x, y);
      if (gameView.blocks[idx].content == null) {
        destinations.add(gameView.blocks[idx]);
      }
    }
  }
  for (Block dest in destinations) {
    insertContent(dest, gameView);
  }
  await waitMoves(gameView);
}

Future<void> insertContent(Block destination, GameView gameView) async {
  int idx = gameView.rnd.nextInt(5);
  Content newContent = Content.create(
      gameView, BlockUtil.getContent(idx), destination.x.toDouble());
  destination.content = newContent;
  while (newContent.content != null && newContent.isMoving) {
    await Future.delayed(Duration(milliseconds: 500));
  }
}

Future<void> waitMoves(GameView gameView) async {
  for (Block block in gameView.blocks) {
    while (block.content != null && block.content.isMoving) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}

bool hasMatches(int x, int y, List<Block> blocks, ContentEnum content) {
  if (x == 2 && content == getContent(x - 1, y, blocks)) {
    return true;
  }
  if (x > 2 && content == getContent(x - 1, y, blocks) && content == getContent(x - 2, y, blocks)) {
    return true;
  }
  if (y == 2 && content == getContent(x, y - 1, blocks)) {
    return true;
  }
  if (y > 2 && content == getContent(x, y - 1, blocks) && content == getContent(x, y - 2, blocks)) {
    return true;
  }
  return false;
}

ContentEnum getContent(int x, int y, List<Block> blocks) {
  int idx = BlockUtil.getIndex(x, y);
  return blocks[idx].content.content;
}

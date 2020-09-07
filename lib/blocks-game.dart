import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:blocks_game/components/block.dart';
import 'package:blocks_game/components/content.dart';
import 'package:blocks_game/components/score-view.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:blocks_game/utils/block-util.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocksGame extends Game {
  Size screenSize;
  double tileSize;
  final SharedPreferences storage;
  List<Block> blocks;
  bool isHandled = false;
  Block selected;
  Block previousSelected;
  bool hasMatches = false;
  Random rnd;
  bool hasMoved = false;
  ScoreView scoreView;

  BlocksGame(this.storage) {
    initialize();
  }

  void initialize() async {
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    blocks = new List();
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 7; x++) {
        // int idx = (x + y) % 4;
        int idx = rnd.nextInt(5);
        blocks.add(Block(this, x, y, BlockUtil.getContent(idx)));
      }
    }
    scoreView = ScoreView(this);
  }

  void render(Canvas canvas) {
    blocks.forEach((block) => block.render(canvas));
    scoreView.render(canvas);
  }

  void update(double t) {
    blocks.forEach((block) => block.update(t));
    scoreView.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = size.width / 9;
  }

  void onTapDown(TapDownDetails details) {
    blocks.forEach((block) {
      if (block.rect.contains(details.globalPosition)) {
        isHandled = true;
        block.onTapDown();
        this.processSelection();
        return;
      }
    });
  }

  Future<void> processSelection() async {
    if (this.previousSelected == null) {
      return;
    }
    if (this.previousSelected == this.selected) {
      this.selected = null;
      this.previousSelected = null;
    }
    if (((this.previousSelected.x - this.selected.x).abs() == 1 &&
            this.previousSelected.y - this.selected.y == 0) ||
        ((this.previousSelected.y - this.selected.y).abs() == 1 &&
            this.previousSelected.x - this.selected.x == 0)) {
      await this.switchContent(this.selected, this.previousSelected);
      this.selected = null;
      this.previousSelected = null;
      this.hasMoved = false;
      await this.process();
      if (!this.hasMoved) {
        await this.switchContent(this.previousSelected, this.selected);
      }
    } else {
      this.previousSelected = null;
    }
  }

  Future<void> process() async {
    this.selected = null;
    this.previousSelected = null;
    this.findRowMatches();
    this.findColumnsMatches();
    if (this.hasMatches) {
      this.hasMoved = true;
      blocks.forEach((block) {
        if (block.isMatch) {
          this.scoreView.score(block.content);
          block.content = null;
          block.isMatch = false;
        }
      });
      await this.dropBlocks();
      await this.fillGaps();
      this.hasMatches = false;
      this.process();
    }
  }

  Future<void> switchContent(Block origin, Block destination) async {
    if (origin.content == null) {
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

  void findRowMatches() {
    for (int y = 0; y < 10; y++) {
      ContentEnum previous;
      List<Block> matches = List();
      for (int x = 0; x < 7; x++) {
        int idx = BlockUtil.getIndex(x, y);
        if (previous != null &&
            blocks[idx].content != null &&
            previous == blocks[idx].content.content) {
          matches.add(blocks[idx]);
        } else {
          if (matches.length > 2) {
            matches.forEach((block) => block.isMatch = true);
            this.hasMatches = true;
          }
          matches.clear();
          previous =
              blocks[idx].content == null ? null : blocks[idx].content.content;
          matches.add(blocks[idx]);
        }
        if (x == 6 && matches.length > 2) {
          matches.forEach((block) => block.isMatch = true);
          this.hasMatches = true;
        }
      }
    }
  }

  void findColumnsMatches() {
    for (int x = 0; x < 7; x++) {
      ContentEnum previous;
      List<Block> matches = List();
      for (int y = 0; y < 10; y++) {
        int idx = BlockUtil.getIndex(x, y);
        if (previous != null &&
            blocks[idx].content != null &&
            previous == blocks[idx].content.content) {
          matches.add(blocks[idx]);
        } else {
          if (matches.length > 2) {
            matches.forEach((block) => block.isMatch = true);
            this.hasMatches = true;
          }
          matches.clear();
          previous =
              blocks[idx].content == null ? null : blocks[idx].content.content;
          matches.add(blocks[idx]);
        }
        if (y == 9 && matches.length > 2) {
          matches.forEach((block) => block.isMatch = true);
          this.hasMatches = true;
        }
      }
    }
  }

  Future<void> dropBlocks() async {
    for (int x = 0; x < 7; x++) {
      Queue<Block> destinations = Queue();
      for (int y = 9; y >= 0; y--) {
        int idx = BlockUtil.getIndex(x, y);
        if (blocks[idx].content == null) {
          destinations.add(blocks[idx]);
        } else {
          if (destinations.isNotEmpty) {
            switchContent(blocks[idx], destinations.removeFirst());
            destinations.add(blocks[idx]);
          }
        }
      }
    }
    for (Block block in blocks) {
      while (block.content != null && block.content.isMoving) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
  }

  Future<void> fillGaps() async {
    List<Block> destinations = List();
    for (int x = 0; x < 7; x++) {
      for (int y = 9; y >= 0; y--) {
        int idx = BlockUtil.getIndex(x, y);
        if (blocks[idx].content == null) {
          destinations.add(blocks[idx]);
        }
      }
    }
    for (Block dest in destinations) {
      insertContent(dest);
    }
    await waitMoves();
  }

  Future<void> insertContent(Block destination) async {
    int idx = rnd.nextInt(5);
    Content newContent = Content.create(
        this, BlockUtil.getContent(idx), destination.x.toDouble());
    destination.content = newContent;
    while (newContent.content != null && newContent.isMoving) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> waitMoves() async {
    for (Block block in blocks) {
      while (block.content != null && block.content.isMoving) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
  }
}

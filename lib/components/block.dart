import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/components/content.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Block {
  final BlocksGame game;
  Sprite sprite;
  Sprite selectedSprite;
  Rect rect;
  final int x;
  final int y;
  bool isMatch = false;
  Content _content;

  Content get content {
    return this._content;
  }

  set content(Content content) {
    this._content = content;
    if (content != null) {
      content.move(this);
    }
  }

  Block(this.game, this.x, this.y, ContentEnum contentEnum) {
    if ((x.isEven && y.isEven) || (x.isOdd && y.isOdd)) {
      this.sprite = Sprite('blocks/block_blue_black.png');
      this.selectedSprite = Sprite('blocks/block_blue_red.png');
    } else {
      this.sprite = Sprite('blocks/block_black.png');
      this.selectedSprite = Sprite('blocks/block_red.png');
    }
    this.rect = Rect.fromLTWH((x + 1) * game.tileSize, (y + 3) * game.tileSize,
        game.tileSize, game.tileSize);
    // this._content = Content(game, contentEnum, this);
    this._content = Content(game, contentEnum, this);
  }

  bool get selected {
    return game.selected == this || game.previousSelected == this;
  }

  void render(Canvas c) {
    if (!selected) {
      this.sprite.renderRect(c, rect);
    } else {
      this.selectedSprite.renderRect(c, rect);
    }
    if (this.content != null) {
      this.content.render(c);
    }
  }

  void update(double t) {
    if (this._content != null) {
      this._content.update(t);
    }
  }

  void onTapDown() {
    game.previousSelected = game.selected;
    game.selected = this;
    this.game.isHandled = false;
  }
}

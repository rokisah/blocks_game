import 'package:blocks_game/components/block.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:blocks_game/utils/block-util.dart';
import 'package:blocks_game/views/game-view.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Content {
  final GameView game;
  final ContentEnum content;
  Sprite sprite;
  Rect _rect;
  Block _parent;
  Offset _targetLocation;
  double stepDistance = 15;
  bool isMoving = false;

  Content(this.game, this.content, this._parent) {
    this.sprite = BlockUtil.getContentSprite(content);
    // this._rect = _parent.rect.deflate(5);
    this._rect = Rect.fromLTWH((this._parent.x + 5) * game.game.tileSize, 0,
            game.game.tileSize, game.game.tileSize).deflate(5);
    this.move(this._parent);
  }

  Content.create(this.game, this.content, double x) {
    this.sprite = BlockUtil.getContentSprite(content);
    this._rect =
        Rect.fromLTWH((x + 1) * game.game.tileSize, game.game.tileSize, game.game.tileSize, game.game.tileSize)
            .deflate(5);
  }

  void render(Canvas c) {
    this.sprite.renderRect(c, this._rect);
  }

  void update(double t) {
    if (isMoving) {
      Offset toTarget =
          this._targetLocation - Offset(this._rect.left, this._rect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        _rect = _rect.shift(stepToTarget);
      } else {
        _rect = _rect.shift(toTarget);
        isMoving = false;
      }
    }
  }

  void move(Block destination) {
    _parent = destination;
    _targetLocation = Offset(
        destination.rect.deflate(5).left, destination.rect.deflate(5).top);
    this.isMoving = true;
  }

  void moveScore(Offset offset) {
    _parent = null;
    _targetLocation = offset;
    this.isMoving = true;
  }
}

import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:blocks_game/components/content.dart';
import 'package:blocks_game/enums/content-enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ScoreView {
  final BlocksGame game;
  TextPainter painterBlue;
  TextPainter painterGreen;
  TextPainter painterOrange;
  TextPainter painterRed;
  TextPainter painterYellow;
  TextPainter painterMoves;
  TextPainter painterLevel;
  TextStyle textStyleBlue;
  TextStyle textStyleGreen;
  TextStyle textStyleOrange;
  TextStyle textStyleRed;
  TextStyle textStyleYellow;
  TextStyle textStyleMoves;
  TextStyle textStyleLevel;
  Offset positionBlue;
  Offset positionGreen;
  Offset positionOrange;
  Offset positionRed;
  Offset positionYellow;
  Offset positionMoves;
  Offset positionLevel;
  int _scoreBlue;
  int _scoreGreen;
  int _scoreOrange;
  int _scoreRed;
  int _scoreYellow;
  int _targetBlue;
  int _targetGreen;
  int _targetOrange;
  int _targetRed;
  int _targetYellow;
  int moves;
  int level;
  List<Content> contents;

  String get _scoreBlueText {
    return _scoreBlue.toString() + "/" + _targetBlue.toString();
  }

  String get _scoreGreenText {
    return _scoreGreen.toString() + "/" + _targetGreen.toString();
  }

  String get _scoreOrangeText {
    return _scoreOrange.toString() + "/" + _targetOrange.toString();
  }

  String get _scoreRedText {
    return _scoreRed.toString() + "/" + _targetRed.toString();
  }

  String get _scoreYellowText {
    return _scoreYellow.toString() + "/" + _targetYellow.toString();
  }

  String get _scoreMovesText {
    return "Movimentos: " + moves.toString();
  }

  String get _scoreLevelText {
    return "Nível: " + level.toString();
  }

  bool get targetAchieved {
    return _scoreBlue >= _targetBlue &&
        _scoreGreen >= _targetGreen &&
        _scoreOrange >= _targetOrange &&
        _scoreRed >= _targetRed &&
        _scoreYellow >= _targetYellow;
  }

  ScoreView(this.game) {
    _scoreBlue = 0;
    _scoreGreen = 0;
    _scoreOrange = 0;
    _scoreRed = 0;
    _scoreYellow = 0;
    initializeTarget();
    painterBlue = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterGreen = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterOrange = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterRed = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterYellow = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterMoves = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    painterLevel = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    textStyleBlue = createTextStyle(Colors.blue);
    textStyleGreen = createTextStyle(Colors.green);
    textStyleOrange = createTextStyle(Colors.orange);
    textStyleRed = createTextStyle(Colors.red);
    textStyleYellow = createTextStyle(Colors.yellow);
    textStyleMoves = createTextStyle(Colors.white);
    textStyleLevel = createTextStyle(Colors.white);

    positionBlue = Offset(game.tileSize, game.tileSize / 2);
    positionGreen = Offset(game.tileSize * 2.5, game.tileSize / 2);
    positionOrange = Offset(game.tileSize * 4, game.tileSize / 2);
    positionRed = Offset(game.tileSize * 5.5, game.tileSize / 2);
    positionYellow = Offset(game.tileSize * 7, game.tileSize / 2);
    positionMoves = Offset(game.tileSize, game.tileSize * 1.5);
    positionLevel = Offset(game.tileSize, game.tileSize * 2.2);
    contents = new List();
    level = game.currentLevel;
  }

  void initializeTarget() {
    switch (game.currentLevel) {
      case 1:
        _targetBlue = 8;
        _targetGreen = 10;
        _targetOrange = 7;
        _targetRed = 10;
        _targetYellow = 10;
        moves = 25;
        break;
      case 2:
        _targetBlue = 16;
        _targetGreen = 13;
        _targetOrange = 12;
        _targetRed = 17;
        _targetYellow = 14;
        moves = 20;
        break;
      case 3:
        _targetBlue = 21;
        _targetGreen = 25;
        _targetOrange = 17;
        _targetRed = 15;
        _targetYellow = 19;
        moves = 15;
        break;
      case 4:
        _targetBlue = 45;
        _targetGreen = 30;
        _targetOrange = 35;
        _targetRed = 45;
        _targetYellow = 40;
        moves = 13;
        break;
      case 5:
        _targetBlue = 50;
        _targetGreen = 55;
        _targetOrange = 50;
        _targetRed = 50;
        _targetYellow = 45;
        moves = 10;
        break;
      default:
        _targetBlue = 100;
        _targetGreen = 100;
        _targetOrange = 100;
        _targetRed = 100;
        _targetYellow = 100;
        moves = 5;
        break;
    }
  }

  void render(Canvas canvas) {
    painterBlue.paint(canvas, positionBlue);
    painterGreen.paint(canvas, positionGreen);
    painterOrange.paint(canvas, positionOrange);
    painterRed.paint(canvas, positionRed);
    painterYellow.paint(canvas, positionYellow);
    painterMoves.paint(canvas, positionMoves);
    painterLevel.paint(canvas, positionLevel);
    contents.forEach((c) => c.render(canvas));
  }

  void update(double t) {
    // if ((painterBlue.text?.text ?? '') != _scoreBlue.toString()) {
    if ((painterBlue.text?.toPlainText() ?? '') != _scoreBlueText) {
      painterBlue.text = TextSpan(text: _scoreBlueText, style: textStyleBlue);
      painterBlue.layout();
      // position = Offset(
      //   (game.screenSize.width / 2) - (painter.width / 2),
      //   (game.screenSize.height * .25) - (painter.height / 2),
      // );
    }
    if ((painterGreen.text?.toPlainText() ?? '') != _scoreGreenText) {
      painterGreen.text =
          TextSpan(text: _scoreGreenText, style: textStyleGreen);
      painterGreen.layout();
    }
    if ((painterOrange.text?.toPlainText() ?? '') != _scoreOrangeText) {
      painterOrange.text =
          TextSpan(text: _scoreOrangeText, style: textStyleOrange);
      painterOrange.layout();
    }
    if ((painterRed.text?.toPlainText() ?? '') != _scoreRedText) {
      painterRed.text = TextSpan(text: _scoreRedText, style: textStyleRed);
      painterRed.layout();
    }
    if ((painterYellow.text?.toPlainText() ?? '') != _scoreYellowText) {
      painterYellow.text =
          TextSpan(text: _scoreYellowText, style: textStyleYellow);
      painterYellow.layout();
    }
    if ((painterMoves.text?.toPlainText() ?? '') != _scoreMovesText) {
      painterMoves.text =
          TextSpan(text: _scoreMovesText, style: textStyleMoves);
      painterMoves.layout();
    }
    if ((painterLevel.text?.toPlainText() ?? '') != _scoreLevelText) {
      painterLevel.text =
          TextSpan(text: _scoreLevelText, style: textStyleLevel);
      painterLevel.layout();
    }
    contents.forEach((c) => c.update(t));
    contents.removeWhere((c) => !c.isMoving);
  }

  void score(Content content) {
    switch (content.content) {
      case ContentEnum.BLUE:
        this._scoreBlue++;
        content.moveScore(this.positionBlue);
        break;
      case ContentEnum.GREEN:
        this._scoreGreen++;
        content.moveScore(this.positionGreen);
        break;
      case ContentEnum.ORANGE:
        this._scoreOrange++;
        content.moveScore(this.positionOrange);
        break;
      case ContentEnum.RED:
        this._scoreRed++;
        content.moveScore(this.positionRed);
        break;
      case ContentEnum.YELLOW:
        this._scoreYellow++;
        content.moveScore(this.positionYellow);
        break;
      default:
    }
    contents.add(content);
  }

  TextStyle createTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 20,
      shadows: <Shadow>[
        Shadow(blurRadius: 7, color: Color(0xff000000), offset: Offset(3, 3)),
      ],
    );
  }
}

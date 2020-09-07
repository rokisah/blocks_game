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
  // TextStyle textStyle;
  TextStyle textStyleBlue;
  TextStyle textStyleGreen;
  TextStyle textStyleOrange;
  TextStyle textStyleRed;
  TextStyle textStyleYellow;
  Offset positionBlue;
  Offset positionGreen;
  Offset positionOrange;
  Offset positionRed;
  Offset positionYellow;
  int _scoreBlue;
  int _scoreGreen;
  int _scoreOrange;
  int _scoreRed;
  int _scoreYellow;

  ScoreView(this.game) {
    _scoreBlue = 0;
    _scoreGreen = 0;
    _scoreOrange = 0;
    _scoreRed = 0;
    _scoreYellow = 0;
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

    textStyleBlue = createTextStyle(Colors.blue);
    textStyleGreen = createTextStyle(Colors.green);
    textStyleOrange = createTextStyle(Colors.orange);
    textStyleRed = createTextStyle(Colors.red);
    textStyleYellow = createTextStyle(Colors.yellow);
    // textStyle = TextStyle(
    //   color: Color(0xffffffff),
    //   fontSize: 50,
    //   shadows: <Shadow>[
    //     Shadow(
    //       blurRadius: 7,
    //       color: Color(0xff000000),
    //       offset: Offset(3, 3),
    //     ),
    //   ],
    // );

    // position = Offset.zero;
    positionBlue = Offset(game.tileSize, game.tileSize / 2);
    positionGreen = Offset(game.tileSize * 2.5, game.tileSize / 2);
    positionOrange = Offset(game.tileSize * 4, game.tileSize / 2);
    positionRed = Offset(game.tileSize * 5.5, game.tileSize / 2);
    positionYellow = Offset(game.tileSize * 7, game.tileSize / 2);
  }

  void render(Canvas c) {
    painterBlue.paint(c, positionBlue);
    painterGreen.paint(c, positionGreen);
    painterOrange.paint(c, positionOrange);
    painterRed.paint(c, positionRed);
    painterYellow.paint(c, positionYellow);
  }

  void update(double t) {
    if ((painterBlue.text?.text ?? '') != _scoreBlue.toString()) {
      painterBlue.text =
          TextSpan(text: _scoreBlue.toString(), style: textStyleBlue);
      painterBlue.layout();
      // position = Offset(
      //   (game.screenSize.width / 2) - (painter.width / 2),
      //   (game.screenSize.height * .25) - (painter.height / 2),
      // );
    }
    if ((painterGreen.text?.text ?? '') != _scoreGreen.toString()) {
      painterGreen.text =
          TextSpan(text: _scoreGreen.toString(), style: textStyleGreen);
      painterGreen.layout();
    }
    if ((painterOrange.text?.text ?? '') != _scoreOrange.toString()) {
      painterOrange.text =
          TextSpan(text: _scoreOrange.toString(), style: textStyleOrange);
      painterOrange.layout();
    }
    if ((painterRed.text?.text ?? '') != _scoreRed.toString()) {
      painterRed.text =
          TextSpan(text: _scoreRed.toString(), style: textStyleRed);
      painterRed.layout();
    }
    if ((painterYellow.text?.text ?? '') != _scoreYellow.toString()) {
      painterYellow.text =
          TextSpan(text: _scoreYellow.toString(), style: textStyleYellow);
      painterYellow.layout();
    }
  }

  void score(Content content) {
    switch (content.content) {
      case ContentEnum.BLUE:
        this._scoreBlue++;
        break;
      case ContentEnum.GREEN:
        this._scoreGreen++;
        break;
      case ContentEnum.ORANGE:
        this._scoreOrange++;
        break;
      case ContentEnum.RED:
        this._scoreRed++;
        break;
      case ContentEnum.YELLOW:
        this._scoreYellow++;
        break;
      default:
    }
  }

  TextStyle createTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 30,
      shadows: <Shadow>[
        Shadow(blurRadius: 7, color: Color(0xff000000), offset: Offset(3, 3)),
      ],
    );
  }
}

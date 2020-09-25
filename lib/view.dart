import 'dart:ui';

import 'package:blocks_game/blocks-game.dart';
import 'package:flutter/gestures.dart';

abstract class View {
  final BlocksGame game;

  View(this.game);

  void render(Canvas canvas);

  void update(double t);

  void resize(Size size);

  void onTapDown(TapDownDetails details);

  void onVerticalDragStart(DragStartDetails details);

  void onVerticalDragEnd(DragEndDetails details);

  void onVerticalDragUpdate(DragUpdateDetails details);
}

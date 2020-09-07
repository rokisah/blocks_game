import 'package:blocks_game/enums/content-enum.dart';
import 'package:flame/sprite.dart';

class BlockUtil {

  static ContentEnum getContent(int idx) {
    switch (idx) {
      case 0:
        return ContentEnum.BLUE;
      case 1:
        return ContentEnum.GREEN;
      case 2:
        return ContentEnum.ORANGE;
      case 3:
        return ContentEnum.RED;
      case 4:
        return ContentEnum.YELLOW;
      default:
        return ContentEnum.YELLOW;
    }
  }

  static getContentSprite(ContentEnum content) {
    if (content == null) {
      return null;
    }
    switch (content) {
      case ContentEnum.BLUE:
        return Sprite('blocks/blue.png');
      case ContentEnum.GREEN:
        return Sprite('blocks/green.png');
      case ContentEnum.ORANGE:
        return Sprite('blocks/orange.png');
      case ContentEnum.RED:
        return Sprite('blocks/red.png');
      case ContentEnum.YELLOW:
        return Sprite('blocks/yellow.png');
      default:
        return Sprite('blocks/yellow.png');
    }
  }

  static int getIndex(int x, int y) {
    return x + (y * 7);
  }

}

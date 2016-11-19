part of game.mobile;

typedef void OnButtonUp();
typedef void OnButtonDown();

class MobileButton {
  ui.Rect area;
  bool isDown = false;
  OnButtonUp onUp;
  OnButtonDown onDown;

  MobileButton(this.area, [this.onDown, this.onUp]);
}

class ControlButton extends MobileButton {
  ControlButton(Game game, int control, ui.Rect area) : super(area) {
    onDown = () {
      game.player.setMove(control, true);
    };
    onUp = () {
      game.player.setMove(control, false);
    };
  }
}

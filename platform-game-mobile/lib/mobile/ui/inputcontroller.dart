part of game.mobile;

class InputControllerWebKeyboard {
  Game game;

  InputControllerWebKeyboard(this.game);
/*
  void handleKey(KeyboardEvent event) {
    int key = event.keyCode;
    bool down = event.type == "keydown"; //event.KEYDOWN

    if (key == 37 || key == 65) //left & a
      game.player.setMove(Player.MOVE_LEFT, down);
    if (key == 39 || key == 68) //right & d
      game.player.setMove(Player.MOVE_RIGHT, down);
    if (key == 38 || key == 87) //up & w
      game.player.setMove(Player.MOVE_JUMP, down);
    if (key == 40 || key == 83) //down & s
      game.player.setMove(Player.MOVE_JUMP2, down);

    if ((key == 13 || key == 81) && down) //enter & q
      game.player.enterObject();
    if (key == 67 && down) //c
      game.showCollisionField = game.showCollisionField == false;
  }*/
}

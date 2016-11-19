part of game.web;

class GameLoopWeb extends GameLoop{
  int jstimer = -1;
  void play() {
    super.play();
    if (jstimer == -1) jstimer = window.requestAnimationFrame(loop);
  }

  void loop(double looptime) {
    super.loop(looptime);
    if (stopping) {
      jstimer = -1;
      return;
    }
    jstimer = window.requestAnimationFrame(loop);
  }
}
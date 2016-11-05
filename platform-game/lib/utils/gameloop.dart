part of Utils;

typedef void OnPlay();
typedef void OnStop();
typedef void OnUpdate(int now);

abstract class GameLoop
{
  //framerate
  int frames = 0;
  int lastTime;
  int time = 0;
  int fps = 0;

  bool stopping = false;
  bool playing = false;

  OnUpdate update;
  OnPlay onPlay;
  OnStop onStop;

  void play() {
    if (playing) return;
    stopping = false;
    playing = true;
    onPlay?.call();
  }

  void stop() {
    stopping = true;
  }

  void pause([bool forceplay = null]) {
    forceplay ??= !playing;
    if (!stopping && !forceplay) {
      stop();
      return;
    }
    //already stopping
    if (!forceplay) return;

    play();
  }

  void loop(double looptime) {
    if (stopping) {
      playing = false;
      onStop?.call();
      return;
    }
    lastTime ??= looptime.toInt();

    //framerate
    int now = looptime.toInt();

    update?.call(now);

    int delta = now - lastTime;
    lastTime = now;
    time += delta;
    frames++;
    if (time > 1000) {
      fps = 1000 * frames ~/ time;
      time = 0;
      frames = 0;
    }
  }
}


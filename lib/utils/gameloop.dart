part of Utils;

typedef void OnPlay();
typedef void OnStop();
typedef void OnUpdate(int now);

class GameLoop
{
  //framerate
  int frames = 0;
  int lastTime;
  int time = 0;
  int fps = 0;
  int jstimer = -1;

  bool stopping = false;
  bool playing = false;

  OnUpdate update;
  OnPlay onPlay;
  OnStop onStop;

  GameLoop(this.update,[this.onPlay, this.onStop]);

  void play()
  {
	if(playing)
		return;
	stopping = false;
	playing = true;
	if(jstimer == -1)
		jstimer = window.requestAnimationFrame(loop);
	if(onPlay != null)
		onPlay();
  }
  
  void stop()
  {
	stopping = true;
  }

  void pause([bool forceplay = null])
  {
	if(forceplay == null)
		forceplay = !playing;
    if(stopping == false && forceplay == false)
    {
      stop();
      return;
    }
	//already stoppingpping
    if(forceplay == false)
      return;
    
    play();
  }

  void loop(double looptime)
  {
    if(stopping == true)
    {
		jstimer = -1;
		playing = false;
		if(onStop != null)
		  onStop();
		return;
    }
    if(lastTime == null)
      lastTime = looptime.toInt();

    //framerate
    int now = looptime.toInt();//(new Date.now()).value;
	
	if(update != null)
      update(now);
	  
	int delta = now-lastTime;
    lastTime = now;
    time += delta;
    frames++;
    if(time > 1000)
    {
      fps = 1000*frames~/time;
      time = 0;
      frames = 0;
    }

    window.requestAnimationFrame(loop);
    return;
  }
}
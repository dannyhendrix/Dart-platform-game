/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

/**
Player class
**/
class Player extends GameObject
{
  //controls states
  static const int MOVE_LEFT = 1;
  static const int MOVE_RIGHT = 2;
  static const int MOVE_JUMP = 3;
  static const int MOVE_JUMP2 = 4;
  
  static const int LOOK_LEFT = 0;
  static const int LOOK_RIGHT = 1;
  
  //character states
  static const int STATE_DEF = 0;
  static const int STATE_WALK = 1;
  static const int STATE_JUMP = 2;
  static const int STATE_JUMP2 = 3;
  static const int STATE_INAIR = 4;
  
  int look = LOOK_RIGHT;
  int state = STATE_INAIR;

  //keeps track of controls that are pressed
  List<int> movepriority;

  Sprite sprite;

  String name = "Player";
  
  int labelwidth = 0;
  int labelheight = 16;
  int padding = 3;
  //object offset from left (caused by the label)
  int labeloffset;
  
  bool changed = false;
  
  double health = 1.0;
  bool healthchanged = true;

  //animations
  static final AnimationFrames _WALK = const AnimationFrames(3,5);
  static final AnimationFrames _STAND = const AnimationFrames(0,2);
  static final AnimationFrames _INAIR = const AnimationFrames(14,14);

  //walk speed
  static final int _step = 10;
  
  InteractiveObject hoverobject;

  Player(Game game) : super(game, 0.0,0.0,22,39+6), movepriority = new List<int>()
  {
    collision.x = 6;
    collision.w = w - 16;
    collision.y = 10+6;
    collision.h = h - 15-6;

    sprite = new Sprite("resources/images/c0v0a16t1uv1t80Cs1Cd.png",0,0,22,39);
    
    //text label
    labelwidth = layer.ctx.measureText(name).width.ceil().toInt()+padding*2;
    
    if(labelwidth > w)
    {
      w = labelwidth;
      collision.x += ((w-22)/2).toInt();
    }
    collision.y += labelheight;
    h += labelheight;
    
    labeloffset = ((w-22)/2).toInt();
    
    layer.height = h;
    layer.width = w;
    
    layer.ctx.fillRect(0, 0, w, 16);
    layer.ctx.setFillColorRgb(255,255,255);
    layer.ctx.fillText(name, padding, 12);
  }
  
  void enterObject()
  {
    if(hoverobject != null)
      hoverobject.onEnter(this);
  }

  void setMove(int move, bool activate)
  {
    //called when a key is pressed or released
    /*
    Keys may only be in the array once. When multiple keys are pressed, 
    the key that is pressed first is first in the array. The key that 
    is last in the array is handled.
    */
    
    /*
    int index = movepriority.indexOf(move);
    if(index > -1)
      movepriority.removeRange(index, 1);
    if(activate == true)
      movepriority.add(move);
    */
    
    movepriority.remove(move);
    if(activate == true)
        movepriority.add(move);
  }
  
  void addHealth(double add)
  {
    health += add;
    if(health <= 0.0)
      die();
    healthchanged = true;
  }
  
  void reset(double newx, double newy)
  {
    x = newx;
    y = newy;
    vector.clear();
    health = 1.0;
    healthchanged = true;
    hoverobject = null;
    changed = true;
    changeState(STATE_INAIR);
  }
  
  void die()
  {
    game.messages.sendMessage("Too bad.. try again!");
    game.resetLevel();
  }
  
  void update(double lastTime, double looptime)
  {
    // default the player does not move, otherwise use the last move action in the array (see setMove)
    int move = -1;
    if(movepriority.length > 0)
      move = movepriority.last;
    setState(move);
    
    prev_x = x;
    prev_y = y;

    //movement is based on fps to make it smooth
    //16 was the original fps
    double diff = looptime-lastTime;
    double add = (16*_step)/1000*diff;
    
    double gravity = Math.min(Game.GRAVITY.toDouble(), 16*Game.GRAVITY/1000*diff);

    handleState(add, looptime, 10, gravity);
    
    //apply vector
    x += 16*vector.xspeed/1000*diff;
    y += 16*vector.yspeed/1000*diff;
    
    bool moved = (x != prev_x || y != prev_y);
    
    //clear hoverobject?
    if(hoverobject != null)
    {
      if( (
          collisionx2 > hoverobject.collisionx
          && collisionx < hoverobject.collisionx2
          && collisiony2 > hoverobject.collisiony
          && collisiony < hoverobject.collisiony2
          ) == false
      )
      {
        hoverobject.onOut(this);
        hoverobject = null;
      }
    }
    
    if(moved)
    {
      onPlatform = false;
      game.level.isCollision(this);
      if(onPlatform == false)
        changeState(STATE_INAIR);
      
      changed = true;
      //set the camera position relative to the player
      game.camera.centerObject(this);
    }
    
    //redraw item
    if(changed == true)
      updateDrawLocation();
    changed = false;
  }
  
  void changeState(int newState)
  {
    //when the state is inAir, changing state is not possible
    if(state == STATE_INAIR && newState != STATE_DEF)
      return;
    state = newState;
  }
  
  void setState(int move)
  {
    switch(move)
    {
      case MOVE_RIGHT:
        look = LOOK_RIGHT;
        changeState(STATE_WALK);
        break;
      case MOVE_LEFT:
        look = LOOK_LEFT;
        changeState(STATE_WALK);
        break;
      case MOVE_JUMP:
        changeState(STATE_JUMP);
        break;
      case MOVE_JUMP2:
        changeState(STATE_JUMP2);
        break;
      default:
        if(state != STATE_INAIR)
          changeState(STATE_DEF);
    }
  }

  void handleState(double add, double looptime, int framerate, double gravity)
  {
    switch(state)
    {
      case STATE_INAIR:
        vector.yspeed += gravity;
        changed = changeImage(_INAIR,looptime,framerate);
        break;
      case STATE_DEF:
        changed = changeImage(_STAND,looptime,framerate);
        break;
      case STATE_WALK:
        if(look == LOOK_LEFT)
          x -= add;
        else
          x += add;
        changed = changeImage(_WALK,looptime,framerate);
        break;
      case STATE_JUMP:
        vector.clear();
        if(look == LOOK_LEFT)
          this.vector.addVector(new Vector.fromAngle(235.0,30.0));
        else
          this.vector.addVector(new Vector.fromAngle(305.0,30.0));
        changeState(STATE_INAIR);
        changed = changeImage(_INAIR,looptime,framerate);
        break;
      case STATE_JUMP2:
        vector.clear();
        if(look == LOOK_LEFT)
          this.vector.addVector(new Vector.fromAngle(260.0,40.0));
        else
          this.vector.addVector(new Vector.fromAngle(280.0,40.0));
        changeState(STATE_INAIR);
        changed = changeImage(_INAIR,looptime,framerate);
        break;
    }
  }

  void paint()
  {
    //clear the character area (and keep the healtbar and name)
    layer.ctx.clearRect(0, 6+labelheight, w, h-6-labelheight);
    if(look == LOOK_LEFT)
      sprite.drawOnPosition(labeloffset,6+labelheight,14 - frame,1,layer);
    else
      sprite.drawOnPosition(labeloffset,6+labelheight,frame,0,layer);
    
    //repaint health if health has changed since the last paint
    if(healthchanged == false)
      return;
    healthchanged = false;
    
    layer.ctx.setFillColorRgb(0,0,0);
    layer.ctx.fillRect(labeloffset, 0+labelheight, 22, 6);
    
    int healthw = ((22-2/100) * health).floor().toInt();
    layer.ctx.setFillColorRgb(0,255,0);
    layer.ctx.fillRect(labeloffset+1, 1+labelheight, healthw, 4);
  }
  
  bool checkCollisionField(double relativex, double relativey, CollisionField collisionfield)
  {
    bool res = super.checkCollisionField(relativex, relativey, collisionfield);
    if(res == false)
      return false;

    if(onPlatform == true)
      changeState(STATE_DEF);

    vector.clear();
    return true;
  }
  
  bool checkTileCollision(LevelTile tile)
  {
    bool res = super.checkTileCollision(tile);
    if(res == false)
      return false;

    //spikes
    if(tile.tileid == 4)
    {
      vector.clear();
      if(look == LOOK_LEFT)
        this.vector.addVector(new Vector.fromAngle(280.0,30.0));
      else
        this.vector.addVector(new Vector.fromAngle(260.0,30.0));
      addHealth(-0.2);
    }
    return true;
  }
  
  bool checkLevelBorderCollision()
  {
    if(y > game.level.y+game.level.h)
      die();

    return false;
  }
  
  bool checkObjectCollision(RenderObject o)
  {
    if(o is InteractiveObject == false)
      return checkObjectCollision(o);
    
    //over object?
    if( (
        collisionx2 > o.collisionx
        && collisionx < o.collisionx2
        && collisiony2 > o.collisiony
        && collisiony < o.collisiony2
        ) == false)
    return false;
    
    if(o is InteractiveObject == false || hoverobject != null || hoverobject == o)
      return false;
    
    InteractiveObject so = o;
    so.onOver(this);
    hoverobject = so;
    return true;
  }
}

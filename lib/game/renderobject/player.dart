/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
Player class
**/
class Player extends GameObject {
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

  bool framechanged = false;

  double health = 1.0;
  bool healthchanged = true;

  //animations
  static final AnimationFrames _WALK = const AnimationFrames(3, 5);
  static final AnimationFrames _STAND = const AnimationFrames(0, 2);
  static final AnimationFrames _INAIR = const AnimationFrames(14, 14);

  //vectors
  static final Vector _JUMP1_LEFT = new Vector.fromAngle(235.0, 6.0);
  static final Vector _JUMP1_RIGHT = new Vector.fromAngle(305.0, 6.0);
  static final Vector _JUMP2_LEFT = new Vector.fromAngle(260.0, 8.0);
  static final Vector _JUMP2_RIGHT = new Vector.fromAngle(280.0, 8.0);

  static final Vector _SPIKES_LEFT = new Vector.fromAngle(280.0, 7.0);
  static final Vector _SPIKES_RIGHT = new Vector.fromAngle(260.0, 7.0);

  static final RenderColor ColorText = const RenderColor(255,255,255);
  static final RenderColor ColorTextBackground = const RenderColor(0,0,0);
  static final RenderColor ColorHealth = const RenderColor(0,255,0);
  static final RenderColor ColorHealthBackground = const RenderColor(0,0,0);

  //walk speed
  static final int _step = 3;

  InteractiveObject hoverobject;

  Player(Game game)
      : super(game, 0.0, 0.0, 22, 39 + 6),
        movepriority = new List<int>() {
    collision = new CollisionField(6, 16, w - 16, h - 21);

    //text label
    labelwidth = layer.getTextWidth(name)+padding*2;
    labelheight = layer.getTextHeight(name)+padding*2;

    
    if(labelwidth > w)    {
      w = labelwidth;
      collision.x += ((w-22)/2).toInt();
    }
    collision.y += labelheight;
    h += labelheight;
    
    labeloffset = ((w-22)/2).toInt();

    layer.resize(w,h);
    
    layer.drawFilledRect(0, 0, w, labelheight, ColorTextBackground);
    layer.drawText(padding, padding, name, ColorText);
  }

  void start(Game game) {
    sprite = new Sprite(game.resourceManager.getImage("player"), 0, 0, 22, 39);
  }

  void enterObject() {
    hoverobject?.onEnter(this);
  }

  void setMove(int move, bool activate) {
    //called when a key is pressed or released
    /*
    Keys may only be in the array once. When multiple keys are pressed, 
    the key that is pressed first is first in the array. The key that 
    is last in the array is handled.
    */
    movepriority.remove(move);
    if (activate) movepriority.add(move);
  }

  void addHealth(double add) {
    health += add;
    if (health <= 0.0) die();
    healthchanged = true;
  }

  void reset(double newx, double newy) {
    x = newx;
    y = newy;
    vector.clear();
    health = 1.0;
    healthchanged = true;
    hoverobject = null;
    framechanged = true;
    changeState(STATE_INAIR);
  }

  void die() {
    game.gameOutput.onGameMessage("Too bad.. try again!");
    game.resetLevel();
  }

  void update() {
    // default the player does not move, otherwise use the last move action in the array (see setMove)
    int move = -1;
    if (movepriority.length > 0) move = movepriority.last;
    setState(move);

    handleState();

    //apply vector
    x += vector.xspeed;
    y += vector.yspeed;

    bool moved = (x != prev_x || y != prev_y);

    if (moved) {
      //check for collisions
      onPlatform = false;
      game.level.repairCollision(this);
      if (!onPlatform) changeState(STATE_INAIR);

      //clear hoverobject?
      if (hoverobject != null) {
        if (!(collisionx2 > hoverobject.collisionx && collisionx < hoverobject.collisionx2 && collisiony2 > hoverobject.collisiony && collisiony < hoverobject.collisiony2)) {
          hoverobject.onOut(this);
          hoverobject = null;
        }
      }
      framechanged = true;
      //set the camera position relative to the player
      game.camera.centerObject(this);
    }

    //redraw item
    if (framechanged == true) updateDrawLocation();
    framechanged = false;
  }

  void changeState(int newState) {
    //when the state is inAir, changing state is not possible
    if (state == STATE_INAIR && newState != STATE_DEF) return;
    if (newState == STATE_INAIR) onPlatform = false;
    state = newState;
  }

  void setState(int move) {
    prev_x = x;
    prev_y = y;
    switch (move) {
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
        if (state != STATE_INAIR) changeState(STATE_DEF);
    }
  }

  void handleState() {
    switch (state) {
      case STATE_INAIR:
        vector.yspeed += Game.GRAVITY;
        framechanged = changeImage(_INAIR);
        break;
      case STATE_DEF:
        framechanged = changeImage(_STAND);
        break;
      case STATE_WALK:
        if (look == LOOK_LEFT)
          x -= _step;
        else
          x += _step;
        framechanged = changeImage(_WALK);
        break;
      case STATE_JUMP:
        vector.clear();
        if (look == LOOK_LEFT)
          this.vector.addVector(_JUMP1_LEFT);
        else
          this.vector.addVector(_JUMP1_RIGHT);
        changeState(STATE_INAIR);
        framechanged = changeImage(_INAIR);
        break;
      case STATE_JUMP2:
        vector.clear();
        if (look == LOOK_LEFT)
          this.vector.addVector(_JUMP2_LEFT);
        else
          this.vector.addVector(_JUMP2_RIGHT);
        changeState(STATE_INAIR);
        framechanged = changeImage(_INAIR);
        break;
    }
  }

  void paint() {
    //clear the character area (and keep the healtbar and name)
    layer.clearArea(0, 6 + labelheight, w, h - 6 - labelheight);
    if (look == LOOK_LEFT)
      sprite.drawOnPosition(labeloffset, 6 + labelheight, 14 - frame, 1, layer);
    else
      sprite.drawOnPosition(labeloffset, 6 + labelheight, frame, 0, layer);

    //repaint health if health has changed since the last paint
    if(healthchanged == false)
      return;
    healthchanged = false;

    layer.drawFilledRect(labeloffset, labelheight, 22, 6, ColorHealthBackground);
    int healthw = ((22-2/100) * health).floor().toInt();
    layer.drawFilledRect(labeloffset+1, 1+labelheight, healthw, 4, ColorHealth);
  }

  bool repairLevelBorderCollision() {
    if (y > game.level.y + game.level.h) die();

    return false;
  }

  void repairCollisionTile(LevelTile tile) {
    super.repairCollisionTile(tile);
    if (isCollisionField(tile.x.toDouble(), tile.y.toDouble() - 1, LevelTile.TILE_COLLISIONFIELD)) onPlatform = true;
  }

  void repairCollisionObject(RenderObject obj) {
    super.repairCollisionObject(obj);
    if (isCollisionField(obj.x, obj.y - 1, obj.collision)) onPlatform = true;
  }

  void onTileCollision(LevelTile tile) {
    super.onTileCollision(tile);
    if (state == STATE_INAIR && onPlatform) changeState(STATE_DEF);
    vector.clear();
    //spikes
    if (tile.tileid == 4) {
      vector.clear();
      if (look == LOOK_LEFT)
        this.vector.addVector(_SPIKES_LEFT);
      else
        this.vector.addVector(_SPIKES_RIGHT);
      addHealth(-0.2);
    }
  }

  void onObjectCollision(RenderObject o) {
    if (!(o is InteractiveObject) || hoverobject != null || hoverobject == o) return;
    InteractiveObject so = o;
    so.onOver(this);
    hoverobject = so;
  }
}

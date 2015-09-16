/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

/**
Simple class for holding animation indexes
**/
class AnimationFrames
{
  final int start;
  final int end;
  final int framerate;

  const AnimationFrames(this.start,this.end, [this.framerate = 8]);
}

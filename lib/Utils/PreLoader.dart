/**
Platform game example
 
@author Danny Hendrix
**/

part of Utils;

/**
load resources, calls a callback when all resources are loaded
**/
class PreLoader 
{
  int loaded = 0;
  int files = 0;
  
  bool started = false;
  
  Function callback;
  
  PreLoader(this.callback);
  
  void start()
  {
    started = true;
    if(loaded >= files)
      callback();
  }
  
  void reset()
  {
    loaded = 0;
    files = 0;
    started = false;
  }
  
  void loadImage(String file)
  {
    files++;
    ImageElement img = ImageController.loadImage(file);
    img.on.load.add((event){ fileloaded(); });
  }
  
  void loadJson(String file)
  {
    files++;
    JsonController.loadJson(file, fileloaded);
  }
  
  void fileloaded()
  {
    loaded++;
    if(started == false)
      return;
    if(loaded >= files)
    {
      started = false;
      callback();
    }
  }
}

/**
Platform game example
 
@author Danny Hendrix
**/

#library('Utils');

#import("dart:html");

/**
image resources holder
**/
class ImageController 
{
  static Map<String,ImageElement> _images;
  
  static ImageElement loadImage(String url, [Function callback])
  {
    if(_images == null)
      _images = new Map<String,ImageElement>();
    
    ImageElement img = new Element.tag("img");
    img.src = url;
    _images[url] = img;
    
    if(callback != null)
      img.on.load.add(callback);
    return img;
  }
  
  static ImageElement getImage(String url)
  {
    if(_images == null)
      _images = new Map<String,ImageElement>();
    if(_images.containsKey(url))
      return _images[url];
    return loadImage(url);
  }
}

/**
Platform game example
 
@author Danny Hendrix
**/

part of Utils;

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
      img.onLoad.listen(callback);
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

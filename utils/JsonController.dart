/**
Platform game example
 
@author Danny Hendrix
**/

#library('Utils');

#import("dart:html");
#import("dart:json");

/**
Json resources holder
**/
class JsonController 
{
  static Map<String,Map> json_objects;

  static Map getJson(String file)
  {
    if(json_objects == null)
      json_objects = new Map<String, Map>();
    
    return json_objects[file];
  }
  
  static void loadJson(final String file, final Function callback)
  {
    if(json_objects == null)
      json_objects = new Map<String, Map>();
    
    new XMLHttpRequest.get(file, (XMLHttpRequest req){
      json_objects[file] = JSON.parse(req.responseText);
      callback();
    });
  }
}

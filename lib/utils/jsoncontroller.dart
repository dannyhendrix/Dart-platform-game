/**
Platform game example
 
@author Danny Hendrix
**/

part of Utils;

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
    
    HttpRequest.getString(file).then((String jsonText)
    {
      json_objects[file] = JSON.decode(jsonText);
      callback();
    });
  }
}

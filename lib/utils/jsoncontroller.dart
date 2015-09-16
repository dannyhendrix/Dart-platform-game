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
  static Map<String,Map> json_objects = new Map<String, Map>();

  static Map getJson(String file)
  {
    return json_objects[file];
  }
  
  static bool isLoaded(String file)
  {
    return json_objects.containsKey(file);
  }
  
  static void loadJson(final String file, final Function callback)
  {
    if(isLoaded(file))
      callback();
    HttpRequest.getString(file).then((String jsonText)
    {
      json_objects[file] = JSON.decode(jsonText);
      callback();
    });
  }
}

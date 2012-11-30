/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import("dart:html");

/**
Display messages during the game in a pop-up 
**/
class MessageController 
{
  List<String> messages;
  DivElement dommessages;
  int timeout;
  bool showing = false;
  
  MessageController(): messages = new List<String>()
  {
    dommessages = new DivElement();
    dommessages.id = "messages";
    dommessages.style.opacity = "0.0";
    //fade-in-out effect
    dommessages.style.transition = "opacity 0.5s ease-in-out";

    document.body.elements.add(dommessages);
  }
  
  void sendMessage(String message)
  {
    messages.add(message);
    displayMessages();
  }
  
  void displayMessages()
  {
    if(showing == true)
      dommessages.innerHTML = "${dommessages.innerHTML}<br/>${messages[0]}";
    else
      dommessages.innerHTML = messages[0];
    
    showing = true;
    messages.removeRange(0, 1);
    
    dommessages.style.opacity = "1.0";
    if(timeout != null)
      window.clearTimeout(timeout);
    timeout = window.setTimeout(hideMessages, 5000);
  }
  
  void hideMessages()
  {
    timeout = null;
    showing = false;
    dommessages.style.opacity = "0.0";
    if(messages.length == 0)
      return;
    timeout = window.setTimeout(displayMessages, 500);
  }
}

/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
Display messages during the game in a pop-up 
**/
class MessageController 
{
  List<String> messages;
  DivElement dommessages;
  Timer timeout;
  bool showing = false;
  
  MessageController(): messages = new List<String>()
  {
    dommessages = new DivElement();
    dommessages.id = "messages";
    dommessages.style.opacity = "0.0";
    //fade-in-out effect
    dommessages.style.transition = "opacity 0.5s ease-in-out";

    document.body.append(dommessages);
  }
  
  void sendMessage(String message)
  {
    messages.add(message);
    displayMessages();
  }
  
  void displayMessages()
  {
    /*if(showing == true)
      dommessages.innerHtml = "${dommessages.innerHtml}<br/>${messages[0]}";
    else*/
    dommessages.innerHtml = messages[0];
    
    showing = true;
    messages.removeRange(0, 1);
    
    dommessages.style.opacity = "1.0";

    if(timeout != null)
      timeout.cancel();
    timeout = new Timer(const Duration(milliseconds: 5000),hideMessages);
  }
  
  void hideMessages()
  {
    timeout = null;
    showing = false;
    dommessages.style.opacity = "0.0";
    if(messages.length == 0)
      return;
    timeout = new Timer(const Duration(milliseconds: 5000),displayMessages);
  }
}

/**
Platform game example
 
@author Danny Hendrix
**/

import 'dart:html';
import 'package:dart_platform_game/game.dart';
import 'package:dart_platform_game/web.dart';

void main() 
{
  Dashboard db = new Dashboard();
  db.init();
  db.start();
}

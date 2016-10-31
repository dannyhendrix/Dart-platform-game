part of game;

abstract class GameOutput
{

  void onGameStart();
  void onGameLevelLoaded();
  void onGameLevelFinished();

  void onGameMessage(String message);
  void onGameGoToLocation(String url);

}
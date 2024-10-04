import 'package:flutter/foundation.dart';

NavigatorController navController = NavigatorController();

class NavigatorController extends ChangeNotifier {
  int selectedIndex = 0;

  updateIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }
}

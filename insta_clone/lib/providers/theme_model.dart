import 'package:flutter/cupertino.dart';

class ThemeModel extends ChangeNotifier{
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeModel(){
    _isDark = false;
  }
  set isDark(bool value){
    _isDark = value;
    notifyListeners();
  }

}
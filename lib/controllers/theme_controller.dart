import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  late final GetStorage _box;
  final String _key = 'isDarkMode';
  
  // Make isDarkMode reactive
  final RxBool _isDarkMode = false.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  Future<void> _initialize() async {
    _box = GetStorage();
    await _loadThemeFromStorage();
  }

  Future<void> _loadThemeFromStorage() async {
    await _box.writeIfNull(_key, false);
    bool savedTheme = _box.read(_key) ?? false;
    _isDarkMode.value = savedTheme;
    
    if (savedTheme) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  Future<void> toggleTheme() async {
    final newValue = !_isDarkMode.value;
    _isDarkMode.value = newValue;
    await _box.write(_key, newValue);
    
    if (newValue) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:get/get.dart';

// class ThemeController extends GetxController {
//   final _box = GetStorage();
//   final _key = 'isDarkMode';

//   bool get isDarkMode => _box.read(_key) ?? false;

//   ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadThemeFromStorage();
//   }

//   void _loadThemeFromStorage() {
//     _box.writeIfNull(_key, false);
//     bool savedTheme = _box.read(_key) ?? false;
//     if (savedTheme) {
//       Get.changeThemeMode(ThemeMode.dark);
//     } else {
//       Get.changeThemeMode(ThemeMode.light);
//     }
//   }

//   void toggleTheme() {
//     final isDarkMode = _box.read(_key) ?? false;
//     _box.write(_key, !isDarkMode);
//     if (!isDarkMode) {
//       Get.changeThemeMode(ThemeMode.dark);
//     } else {
//       Get.changeThemeMode(ThemeMode.light);
//     }
//   }
// }

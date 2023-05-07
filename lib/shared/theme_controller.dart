import 'package:get/get.dart';
import 'package:pharmacy_chatbot/shared/themes.dart';

class ThemeController extends GetxController {
  var currentTheme = AppTheme.lightTheme.obs;

  void changeTheme() {
    currentTheme.value =
    currentTheme.value == AppTheme.lightTheme ? AppTheme.darkTheme : AppTheme.lightTheme;
    Get.changeTheme(currentTheme.value);
  }

  String getThemeName() {
    return currentTheme.value == AppTheme.lightTheme ? "Light" : "Dark";
  }
}
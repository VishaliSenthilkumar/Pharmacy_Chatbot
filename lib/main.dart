import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/model/user.dart';
import 'package:pharmacy_chatbot/screens/authenticate/password_reset.dart';
import 'package:pharmacy_chatbot/screens/authenticate/sign_in.dart';
import 'package:pharmacy_chatbot/screens/home/home.dart';
import 'package:pharmacy_chatbot/screens/home/profile.dart';
import 'package:pharmacy_chatbot/screens/home/profile_update.dart';
import 'package:pharmacy_chatbot/screens/wrapp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_chatbot/shared/themes.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';

void main() async {
  // Call Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _themeController.currentTheme.value,
      home: StreamProvider<UserModel?>.value(
        initialData: null,
        value: AuthService().user,
        child: Wrapp(),
      ),
      getPages: [
        GetPage(name: '/', page: () => Wrapp()),
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/update_profile', page: () => ProfileUpdate()),
        GetPage(name: '/forget_password', page: () => PasswordReset()),
      ],
      // builder: (BuildContext context, Widget? child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //     child: child!,
      //   );
      // },
    );
  }
}




import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/screens/chatbot/chat.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_chatbot/model/user.dart';

enum Options { profile, logout }

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ThemeController _themeController = Get.put(ThemeController());

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);

    PopupMenuItem _buildPopupMenuItem(
        String title, IconData iconData, int position) {
      return PopupMenuItem(
        value: position,
        child:  Row(
          children: [
            Icon(iconData, color: Colors.black,),
            Text(title),
          ],
        ),
      );
    }

    _onMenuItemSelected(int value) {
      setState(() {

      });

      if (value == Options.profile.index) {
        Get.toNamed('/profile',arguments: {
          "uid" : user!.uid
        });
      } else {
        _auth.signOut();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text("Pharmacy Chatbot"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              _themeController.changeTheme();
            },
          ),
          // IconButton(
          //     onPressed: (){
          //       // _auth.signOut();
          //     },
          //     icon: Icon(Icons.person),
          // ),
          PopupMenuButton(
            onSelected: (value) {
              _onMenuItemSelected(value as int);
            },
            itemBuilder: (ctx) => [
              _buildPopupMenuItem('Profile', Icons.person, Options.profile.index),
              _buildPopupMenuItem('Logout', Icons.logout, Options.logout.index),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(child: Chat()),
      ),
    );
  }
}





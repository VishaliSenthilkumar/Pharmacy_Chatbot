import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:get/get.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';
import 'package:pharmacy_chatbot/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({required this.toggleView}) ;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final ThemeController _themeController = Get.put(ThemeController());

  final AuthService _auth = AuthService();
  String error="";

  String email = "";

  String password = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
        "Pharmacy Chatbot",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              _themeController.changeTheme();
            },
          ),
          SizedBox(width: 10.0)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                Text(
                  "Hello There..!",
                  style: TextStyle(
                      fontSize: 50,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                        ),
                      ],
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                  ),
                ),
                SizedBox(height: 25.0,),
                Text(
                    "Sign in to chat",
                  style: TextStyle(
                    fontSize: 35,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                  ),
                ),
                SizedBox(height: 35.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',

                  ),
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10.0,),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEandP(email, password);
                      if(result == null){
                        setState(() {
                          error = "Invalid email or password";
                          loading = false;
                        });
                      }
                    },
                    child: Text("Sign in"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/forget_password');
                  },
                  child: Text(
                    "Forget Password?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 50.0,
                    ),

                    Text(
                        "Don't have an account ? ",
                        textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text(
                          "Register",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

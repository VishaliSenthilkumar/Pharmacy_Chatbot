import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}
AuthService _auth = AuthService();
final ThemeController _themeController = Get.put(ThemeController());
final _formkey = GlobalKey<FormState>();

String email = "";

class _PasswordResetState extends State<PasswordReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 150.0,),
                TextFormField(
                  validator: (val) =>  val!.trim().isEmpty ? "Email can't be empty" : EmailValidator.validate(val!) ? null : "Enter a valid email",
                  decoration: InputDecoration(
                    hintText: 'Email: ',
                    labelText: 'Enter the email',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 10.0,),
                ElevatedButton(
                  onPressed: () async {
                  if(_formkey.currentState!.validate()) {
                    print(email);
                    dynamic result = await _auth.resetPassword(email);
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password Reset Link has been sent to the registered email"),
                          )
                      );
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No user with the entered email found"),
                          )
                      );
                    }
                  }
                  },
                  child: Text("Send Reset Password Link"),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "back to Sign in page?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

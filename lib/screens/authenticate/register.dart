import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/screens/authenticate/sign_in.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';
import 'package:get/get.dart';
import 'package:pharmacy_chatbot/shared/loading.dart';


class Register extends StatefulWidget {

  final Function toggleView;

  Register({required this.toggleView}) ;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final ThemeController _themeController = Get.put(ThemeController());

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String error ="";

  String email = "";
  String password = "";
  String name = "";
  String cpassword = "";
  String address = "";
  String age = "";

  final RegExp nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
  final addressRegex = RegExp(r'^[a-zA-Z0-9\s,]+$');

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText = "Enter a password to check it's status";
  double _strength = 0;
  String _password = "";
  bool _passwordState = false ;

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = "Enter a password to check it's status";
        _passwordState = false;
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
        _passwordState = false;
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is not strong';
        _passwordState = false;
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
          _passwordState = true;
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
          _passwordState = true;
        });
      }
    }
  }

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
            key: _formkey,
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
                  "Register here",
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
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  validator: (val) => val!.trim().isEmpty ? "Name can't be empty" : nameRegex.hasMatch(val) ? null : "Enter a valid address",
                  onChanged: (val){
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Age',
                  ),
                  validator: (val) => val!.trim().isEmpty ? "Age can't be empty" : int.parse(age)>=18 && int.parse(val)<180 ? null : "Age must be above 18" ,
                  onChanged: (val){
                    setState(() {
                      age = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (val) =>  val!.trim().isEmpty ? "Email can't be empty" : EmailValidator.validate(val!) ? null : "Enter a valid email",
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                  validator: (val) => val!.trim().isEmpty ? "Address can't be empty" : addressRegex.hasMatch(val) ? null : "Enter a valid address" ,
                  onChanged: (val){
                    setState(() {
                      address = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  validator: (val) =>  _passwordState ? null : "Enter a strong password",
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: (val){
                    _checkPassword(val);
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 10.0,),
                LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  color: _strength <= 1 / 4
                      ? Colors.red
                      : _strength == 2 / 4
                      ? Colors.yellow
                      : _strength == 3 / 4
                      ? Colors.blue
                      : Colors.green,
                  minHeight: 15,
                ),
                const SizedBox(
                  height: 10,
                ),

                // The message about the strength of the entered password
                Text(
                  _displayText,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) => val == password ? null : "Password doesn't match",
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  onChanged: (val){
                    setState(() {
                      cpassword = val;
                    });
                  },
                ),
                SizedBox(height: 10.0,),
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
                  if(_formkey.currentState!.validate() && password==cpassword){
                    dynamic result = await _auth.registerWithEandP(name, int.parse(age), address, email, password);
                    if(result == null){
                      setState(() {
                        error = "Error with the email";
                        loading = false;
                      });
                    }
                    // print("registered");
                  }
                  else if(password!=cpassword){
                    setState(() {
                      error = "password doesn't match with confirm password";
                      loading = false;
                    });
                  }
                },
                    child: Text("Register")
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40.0,
                    ),
                    Text(
                      "Alreaady have an account ? ",
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: Text(
                        "Sign in",
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

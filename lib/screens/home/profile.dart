import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/model/user.dart';
import 'package:pharmacy_chatbot/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_chatbot/services/database.dart';
import 'package:pharmacy_chatbot/shared/loading.dart';
import 'package:get/get.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final ThemeController _themeController = Get.put(ThemeController());

  final AuthService _auth = AuthService();

  final String uid= Get.arguments["uid"];

  Map<String, dynamic>? data = { };
  bool loading = true;
  String date = "";


  Future<void> fetchData () async{

    dynamic result = await DatabaseService(uid: uid).fetchUserData(uid);
    Timestamp timestamp = await result!["registered_time"];
    DateTime dateTime = timestamp.toDate();

    String formatDate(DateTime date) {
      // Format the date as yyyy-MM-dd
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(date);

      // Split the formatted date by the hyphen
      List<String> parts = formatted.split('-');

      // Reverse the order of the parts
      List<String> reversed = parts.reversed.toList();

      // Join the reversed parts with hyphens
      String reversedFormatted = reversed.join('-');

      return reversedFormatted;
    }

    setState(() {
      data = result;
      loading=false;
      date = formatDate(dateTime);
    });

  }

  void initState() {
    super.initState();
    fetchData();
    print(data);
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          'Profile'
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
          IconButton(
              onPressed: () async{
                await _auth.signOut();
                Get.offAllNamed('/');
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                // backgroundImage: NetworkImage(
                //
                // ),
              ),
              SizedBox(height: 20),
              Text(
                data!['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 30),

              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      child: Text(
                          "Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                          ":",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      child: Text(
                          data!['name'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      child: Text(
                        data!['email'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      child: Text(
                        "Age",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      child: Text(
                        data!['age'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      child: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      child: Text(
                        data!['address'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      child: Text(
                        "Account created on",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   IconButton(
                       icon: Icon(Icons.arrow_forward_ios),
                     onPressed: () async {
                         print(data);
                         dynamic result = await Get.toNamed("/update_profile",
                           arguments: {
                             "uid": uid,
                             "data": data,
                             "date": date,
                           },
                         );
                         if(result==true){
                           fetchData();
                         }
                     },
                   ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () async {
                      dynamic result = await _auth.resetPassword(data!['email']);
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password Reset Link has been sent to the registered email"),
                          )
                        );
                      }
                    }
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () async{
                      dynamic result = await _auth.deleteAccount();
                      if(result!=null){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User account deleted successfully"),
                            )
                        );
                        Get.offAllNamed('/');
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Can't delete the account"),
                            )
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

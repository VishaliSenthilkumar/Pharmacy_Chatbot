import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_chatbot/services/database.dart';
import 'package:pharmacy_chatbot/shared/loading.dart';
import 'package:pharmacy_chatbot/shared/theme_controller.dart';
import 'package:pharmacy_chatbot/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  final ThemeController _themeController = Get.put(ThemeController());

  final AuthService _auth = AuthService();

  final _formkey = GlobalKey<FormState>();

  bool loading=false;

  static String uid= Get.arguments["uid"];
  static Map data = Get.arguments["data"];
  String date = Get.arguments["date"];

  final DatabaseService _databaseService = DatabaseService(uid: uid);

  final RegExp nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
  final addressRegex = RegExp(r'^[a-zA-Z0-9\s,]+$');

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

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


  String error ="";

  String email = data?["email"] ?? "";
  String name = data?["name"] ?? "";
  String address = data?["address"] ?? "";
  String age = data?["age"].toString() ?? "";

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
            'Update Profile'
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
              onPressed: () {
                _auth.signOut();
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              TextFormField(
                initialValue: data!['name'],
                decoration: InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name : ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
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
                initialValue: data!['age'].toString(),
                decoration: InputDecoration(
                  hintText: 'Age',
                  labelText: 'Age : ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
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
                initialValue: email,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email : ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                initialValue: data['address'],
                decoration: InputDecoration(
                  hintText: 'Address',
                  labelText: 'Address : ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
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
                initialValue: date,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'date',
                  labelText: 'Account created on : ',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    if(_formkey.currentState!.validate()) {
                      print(name);
                      print(age);
                      print(address);
                        dynamic result = await _databaseService.updateUserData(name, int.parse(age), address);
                        print(result);
                          setState(() {
                            error = "";
                          });
                          fetchData();
                          Get.back(result: true);
                        setState(() {
                          loading = false;
                        });
                    }
                  },
                  child: Text("Update")
              ),
            ],
          ),
        ),
      ),
    );
  }
}

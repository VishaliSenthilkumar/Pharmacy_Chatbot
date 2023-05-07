import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/model/user.dart';
import 'package:pharmacy_chatbot/screens/authenticate/authenticate.dart';
import 'package:pharmacy_chatbot/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_chatbot/shared/loading.dart';

class Wrapp extends StatelessWidget {
  const Wrapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);

    print(user);
    if(user!=null) print(user!.uid);

    if(user==null) return Authenticate();
    else return Home();
  }
}

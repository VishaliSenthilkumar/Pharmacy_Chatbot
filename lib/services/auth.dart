import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_chatbot/model/user.dart';
import 'package:pharmacy_chatbot/screens/authenticate/register.dart';
import 'package:pharmacy_chatbot/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser (User? user) {
    return user!=null ? UserModel(uid: user.uid) : null;
  }

  //auth change
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(
        (User? user) => _userFromFirebaseUser(user)
    );
  }

  //sign in anon
  Future signInanon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email and password

  Future signInWithEandP(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerWithEandP (String name, int age, String address, String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).createUserData(name, age, email, address);
      return _userFromFirebaseUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future deleteAccount() async {
    User user;
    if (_auth != null) {
      user = await _auth.currentUser!;
      user.delete();
      return "success";
    }
    return null;
  }


}
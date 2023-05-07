import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference profileCollection = FirebaseFirestore.instance.collection("profiles");

  Future createUserData(String name, int age, String email, String address ) async {
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    return await profileCollection.doc(uid).set({
      'name':name,
      'age':age,
      'email':email,
      'address':address,
      "registered_time": timestamp
    });
  }

  Future updateUserData(String name, int age, String address ) async {
    try {
      print(uid);
      print(name);
      print(age);
      print(address);
      return await profileCollection.doc(uid).update({
        'name':name,
        'age':age,
        'address':address,
      });
    }
    catch(e){
      print(">>><<<<<<<<<<<<<<<<<<");
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('profiles').doc(userId);
    DocumentSnapshot snapshot = await userRef.get();
    if (snapshot.exists) {
      print(snapshot.data());
      return snapshot.data() as Map<String, dynamic>?;
    } else {
      print("can't able to fetch");
      return null;
    }
  }

}
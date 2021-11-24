import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService{

  // final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  Future updateUserData(String lastname, String firstname, String email, String password) async {
    return await userCollection.doc(uid).set({
      'lastname': lastname,
      'firstname': firstname,
      'email': email,
      'password': password,
    });
  }

}
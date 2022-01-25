import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  Future googleLogin(usertype, isFirstTime) async {
    try{
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if(isFirstTime){
        final User user = auth.currentUser;
        final uid = user.uid;
        final usersRef = databaseReference.child('users/' + uid + '/personal_info');
        final fitbitRef = databaseReference.child('users/' + uid + '/fitbit_connection/');
        fitbitRef.update({"isConnected": "false"});
        String name = _user.displayName;
        String lastName = "";
        String firstName= "";
        var names = name.split(' ');
        firstName = names[0] + names[1];
        lastName = names[2];
        await usersRef.set({"uid": uid.toString(), "firstname": firstName, "lastname": lastName.toString(),
          "email": _user.email.toString(), "password": "ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae", "isFirstTime": true.toString(), "userType": usertype.toString()});
      }
      notifyListeners();
    } catch (e){
      print(e.toString());
    }

  }


  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

}
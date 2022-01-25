import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:my_app/database.dart';
import 'package:my_app/models/users.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FacebookLogin();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  // create user

  Users _userCreated(User user){
    return user != null ? Users(uid: user.uid) : null;
  }

  Stream<Users> get user {
    return _auth.authStateChanges().map(_userCreated);
  }

  Future signInAnon () async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userCreated(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // Register user
  Future registerUser(String lastname, String firstname, String email, String password) async {
  // Future registerUser(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(lastname, firstname, email, password);
      return _userCreated(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //log in user
  Future logInUser(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userCreated(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  loginFacebook(String usertype, isFirstTime) async {
    print("Starting Facebook login");

    final facebookLogin = FacebookLogin();
    final res = await facebookLogin.logIn(customPermissions: ['email']);

    switch(res.status){
      case FacebookLoginStatus.success:
        print("facebook login success");
        final FacebookAccessToken fbToken = res.accessToken;
        //convert to Auth Credential
        final AuthCredential credential = FacebookAuthProvider.credential(fbToken.token);
        //User Credential to sign in with firebase
        final result = await _auth.signInWithCredential(credential);
        if(isFirstTime){
          final User user = auth.currentUser;
          final uid = user.uid;
          final usersRef = databaseReference.child('users/' + uid + '/personal_info');
          final fitbitRef = databaseReference.child('users/' + uid + '/fitbit_connection/');
          fitbitRef.update({"isConnected": "false"});
          String name = result.user.displayName;
          String lastName = "";
          String firstName= "";
          var names = name.split(' ');
          firstName = names[0];
          lastName = names[1];
          await usersRef.set({"uid": uid.toString(), "firstname": firstName, "lastname": lastName.toString(),
            "email": result.user.email.toString(), "password": "ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae", "isFirstTime": true.toString(), "userType": usertype.toString()});
        }
        print('${result.user.displayName} is now logged in');
        break;
      case FacebookLoginStatus.cancel:
        print("The user canceled the login");
        break;
      case FacebookLoginStatus.error:
        print("There was an error");
        break;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}
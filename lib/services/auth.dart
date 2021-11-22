import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:my_app/database.dart';
import 'package:my_app/models/users.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FacebookLogin();

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

  loginFacebook() async {
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'additional_data_collection.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class registration extends StatefulWidget {
  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<registration> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.close),

                    ),

                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/heart_icon.png"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            showCursor: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize,
                              ),
                              hintText: "First Name",
                            ),
                            validator: (val) => val.isEmpty ? 'Enter First Name' : null,
                            onChanged: (val){
                              setState(() => firstname = val);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            showCursor: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize,
                              ),
                              hintText: "Last Name",
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Last Name' : null,
                            onChanged: (val){
                              setState(() => lastname = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      showCursor: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Email",
                      ),
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val){
                        setState(() => email = val);
                      },
                    ),SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      showCursor: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Password",
                      ),
                      validator: (val) => val.length < 6 ? 'Password should be more than 6 characters' : null,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(17.0),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            dynamic result = await _auth.registerUser(lastname, firstname, email,password);
                            if(result == null){
                              setState(() => error = 'Register Failed');
                            }else{
                              setState(() => error = '');
                            }
                          }
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final usersRef = databaseReference.child('users/' + uid);
                            await usersRef.set({"firstname": firstname.toString(), "lastname": lastname.toString(), "email": email.toString(), "password": password.toString()});
                            print("user registered Sucessfully!");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => additional_data_collection()),
                            );
                          } catch(e) {
                            print("you got an error! $e");
                          }

                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins-Medium.ttf',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        color: Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            side: BorderSide(color: Color(0xFF2196F3))),
                      ),

                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF2196F3)),

                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

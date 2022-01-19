import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/goal_tab/sleep/sleep_list_patient_view.dart';
import 'package:my_app/goal_tab/weight/weight_list_patient_view.dart';
import 'package:my_app/goal_weight.dart';
import 'package:my_app/medical_history.dart';
import 'package:my_app/models/tabIcon_data.dart';
import 'package:my_app/notifications/notifications._patients.dart';
import 'package:my_app/profile/patient/add_image.dart';
import 'package:my_app/profile/patient/edit_medical_history.dart';
import 'package:my_app/profile/support_system/suppsystem_view_patient_profile.dart';
import 'package:my_app/provider/google_sign_in.dart';
import 'package:my_app/reviews/add_restaurant_review.dart';
import 'package:my_app/reviews/specific_restaurant_reviews.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/storage_service.dart';
import 'package:../my_app/dashboards/dashboards.dart';
import 'package:flutter/material.dart';
import 'package:my_app/set_up.dart';
import 'package:my_app/support_system_journal/patient_or_doctor/journal_list_patient_and_doctor_view.dart';
import 'package:my_app/support_system_journal/support_system/journal_list_suppsystem_view.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'allergies.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'discussion_board/discussion.dart';
import 'package:my_app/discussion_board/discussion.dart';
import 'fitness_app_theme.dart';
// import 'food/food_list.dart';
import 'goal_tab/water/water_intake_patient_view.dart';
import 'goal_tab/exercises/exercise_screen.dart';
import 'package:my_app/registration.dart';
import 'package:my_app/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'package:my_app/lab_results_test_borj.dart';
import 'package:my_app/medical_history.dart';
import 'package:my_app/profile/patient/patient_view_support_system.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsDoctor.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsPatient.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_patient.dart';
import 'package:my_app/patient_list/doctor/doctor_add_patient.dart';
import 'package:my_app/patient_list/doctor/doctor_patient_list.dart';
import 'goal_tab/meals/meals_list.dart';
import 'patient_list/support_system/suppsystem_patient_list.dart';





Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LogIn());
}

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
  
}
String isFTime;
String usertype = "";
class _LogInState extends State<LogIn> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();


  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    usertype = "";
    isFirstTime();
    getUserType();
    return ChangeNotifierProvider(
      create: (ctx) => GoogleSignInProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CVD Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot){
          if(snapshot.hasError){
            print('You have an Error! ${snapshot.error.toString()}');
            return Text('Something went wrong!');
          } else if(snapshot.hasData){

            FirebaseAuth.instance
                .authStateChanges()
                .listen((User user) {
              if (user == null) {
                print('User is currently signed out!');
                // return runApp(AppSignIn());
              } else {

                print('User is signed in!');
                Future.delayed(const Duration(milliseconds: 2000), (){
                  setState(() {
                    print("SETSTATE INSIDE WIDGET ");
                    print("USER TYPE IS " + usertype);
                    if(usertype == "Patient"){
                      print("should be PATIENT " + usertype);
                      if(isFTime == "false"){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => mainScreen()),
                              (route) => false,
                        );
                        print("isFTime == false");
                      }
                      else if(isFTime == "true"){
                        print("True isFTime first time");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => set_up()),
                              (route) => false,
                        );
                      }
                    }else if(usertype == null){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AppSignIn()),
                            (route) => false,
                      );
                    }else if(usertype=="Doctor"){
                      print("IS DOCTOR? == " + usertype);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => PatientList()),
                            (route) => false,
                      );
                    }else if(usertype== "Family member / Caregiver"){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => PatientListSupportSystemView()),
                            (route) => false,
                      );
                    }
                  });
                });
                print(isFTime);


              }
            });

            return AppSignIn();
            return Text('This Instance');
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      ),
    );
  }
  void isFirstTime () async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final userRef = databaseReference.child('users/' + uid +'/personal_info/isFirstTime/');
    await userRef.once().then((DataSnapshot datasnapshot) {
      String temp1 = datasnapshot.value.toString();
      if(temp1 == "false"){
        isFTime = "false";
        print("false statement " + isFTime.toString());
        print("TEMP = " +temp1);
      }
      else{
        isFTime= "true";
        print("true statement " + isFTime.toString());
      }
    });
  }
  void getUserType () async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final userRef = databaseReference.child('users/' + uid +'/personal_info/userType/');
    await userRef.once().then((DataSnapshot datasnapshot) {
      usertype = datasnapshot.value.toString();
      print("user type = " + usertype);
    });
  }
}


class AppSignIn extends StatefulWidget {
  @override
  _AppSignInState createState() => _AppSignInState();
}

class _AppSignInState extends State<AppSignIn> {
  // final database = FirebaseDatabase("https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  // File file;
  bool _isHidden = true;


  @override
  Widget build(BuildContext context) {
    // final fileName = file != null ? basename(file!.path) :'No File Selected';

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          children: [
            Container(

              margin: EdgeInsets.only(top: 55.0),
              alignment: Alignment.center,
              child: GestureDetector(

                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => suppsystem_view_patient_profile()),
                    );
                  },
                  child: Image.asset("assets/images/heartistant_logo.png", width: 280, height: 180,)),

            ),
            SizedBox(height: 30.0),
            Container(

              alignment: Alignment.topLeft,
              child:  Text( "Welcome,", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(

              alignment: Alignment.topLeft,
              child:  Text( "Sign in to continue!", style: TextStyle( color: Colors.grey, ),
              ),
            ),
            Container(
                child: Column(
                  children: [
                    SizedBox(height: 8.0),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                showCursor: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width:0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Color(0xFF666666),
                                    size: defaultIconSize,
                                  ),
                                  fillColor: Color(0xFFF2F3F5),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: defaultFontFamily,
                                    fontSize: defaultFontSize),
                                  hintText: "Email Address *",
                                ),
                                validator: (val) => val.isEmpty ? 'Enter Email Address' : null,
                                onChanged: (val){
                                  setState(() => email = val);
                                },
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              child: TextFormField(
                                obscureText: _isHidden,
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
                                    Icons.lock,
                                    color: Color(0xFF666666),
                                    size: defaultIconSize,
                                  ),
                                  suffix: InkWell(
                                    onTap: _togglePassword,
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Color(0xFF666666),
                                      size: defaultIconSize,
                                    ),
                                  ),
                                  // suffixIcon: Icon(
                                  //   Icons.remove_red_eye,
                                  //   color: Color(0xFF666666),
                                  //   size: defaultIconSize,
                                  // ),
                                  fillColor: Color(0xFFF2F3F5),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: defaultFontFamily,
                                    fontSize: defaultFontSize,
                                  ),
                                  hintText: "Password *",
                                ),
                                validator: (val) => val.isEmpty ? 'Enter Password' : null,
                                onChanged: (val){
                                  setState(() => password = val);
                                },
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(height: 10.0),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(minimumSize: Size(220, 0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text('Sign In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                onPressed: () async{
                                  if(_formKey.currentState.validate()){
                                    dynamic result = await _auth.logInUser(email,password);
                                    if(result == null){
                                      setState(() => error = 'Sign In failed: Invalid email or password.');
                                    } else{
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 20,),
                                          Text("Loading")
                                        ],
                                      );
                                      setState(() => error = '');
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  SignInButton(
                                    Buttons.Facebook,
                                    onPressed: () => _auth.loginFacebook(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                minimumSize: Size(220, 40),
                              ),
                                icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                                label: Text("Sign in with Google"),
                                onPressed: (){
                                final provider = Provider.of<GoogleSignInProvider>(context, listen:false);
                                provider.googleLogin();
                               },
                            ),
                            SizedBox(height: 15.0),
                            // Flexible(
                            //   flex:1,
                            //   child: Align(
                            //     alignment: Alignment.bottomCenter,
                            //     child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: <Widget>[
                            //           Container(
                            //             child: Text(
                            //               "Don't have an account? ",
                            //               style: TextStyle(
                            //                 color: Color(0xFF666666),
                            //                 fontFamily: defaultFontFamily,
                            //                 fontSize: defaultFontSize,
                            //                 fontStyle: FontStyle.normal,
                            //               ),
                            //             ),
                            //           ),
                            //         ]
                            //     ),
                            //   ),
                            // ),

                            Container(
                              margin: EdgeInsets.fromLTRB(10,20,10,20),
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(text: "Don\'t have an account? "),
                                        TextSpan(
                                          text: 'Sign Up',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => registration()));
                                            },
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                        ),
                                      ]
                                  )
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
          ],
        ),
      ),




      // body: Container(
      //   padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
      //   width: double.infinity,
      //   height: double.infinity,
      //   color: Colors.white70,
      //   child:Form(
      //     key: _formKey,
      //     child: Column(
      //       children: <Widget>[
      //         Flexible(
      //           flex: 5,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Container(
      //                 width: 130,
      //                 height: 130,
      //                 alignment: Alignment.center,
      //                 child: Image.asset("assets/images/heart_icon.png"),
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               TextFormField(
      //                 showCursor: true,
      //                 decoration: InputDecoration(
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //                     borderSide: BorderSide(
      //                       width: 0,
      //                       style: BorderStyle.none,
      //                     ),
      //                   ),
      //                   filled: true,
      //                   prefixIcon: Icon(
      //                     Icons.mail,
      //                     color: Color(0xFF666666),
      //                     size: defaultIconSize,
      //                   ),
      //                   fillColor: Color(0xFFF2F3F5),
      //                   hintStyle: TextStyle(
      //                       color: Color(0xFF666666),
      //                       fontFamily: defaultFontFamily,
      //                       fontSize: defaultFontSize),
      //                   hintText: "Email Address",
      //                 ),
      //                 validator: (val) => val.isEmpty ? 'Enter Email' : null,
      //                 onChanged: (val){
      //                   setState(() => email = val);
      //                 },
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               TextFormField(
      //                 showCursor: true,
      //                 obscureText: true,
      //                 decoration: InputDecoration(
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //                     borderSide: BorderSide(
      //                       width: 0,
      //                       style: BorderStyle.none,
      //                     ),
      //                   ),
      //                   filled: true,
      //                   prefixIcon: Icon(
      //                     Icons.lock_outline,
      //                     color: Color(0xFF666666),
      //                     size: defaultIconSize,
      //                   ),
      //                   suffixIcon: Icon(
      //                     Icons.remove_red_eye,
      //                     color: Color(0xFF666666),
      //                     size: defaultIconSize,
      //                   ),
      //                   fillColor: Color(0xFFF2F3F5),
      //                   hintStyle: TextStyle(
      //                     color: Color(0xFF666666),
      //                     fontFamily: defaultFontFamily,
      //                     fontSize: defaultFontSize,
      //                   ),
      //                   hintText: "Password",
      //                 ),
      //                 validator: (val) => val.isEmpty ? 'Enter Password' : null,
      //                 onChanged: (val){
      //                   setState(() => password = val);
      //                 },
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               Container(
      //                 width: double.infinity,
      //                 child: Text(
      //                   "Forgot your password?",
      //                   style: TextStyle(
      //                     color: Color(0xFF666666),
      //                     fontFamily: defaultFontFamily,
      //                     fontSize: defaultFontSize,
      //                     fontStyle: FontStyle.normal,
      //                   ),
      //                   textAlign: TextAlign.end,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               Container(
      //                 width: double.infinity,
      //                 child: RaisedButton(
      //                   padding: EdgeInsets.all(17.0),
      //                   onPressed: () async {
      //                     if(_formKey.currentState.validate()){
      //                       dynamic result = await _auth.logInUser(email,password);
      //                       if(result == null){
      //                         setState(() => error = 'Invalid Credential');
      //                       } else{
      //                         setState(() => error = '');
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(builder: (context) => mainScreen()),
      //                         );
      //                       }
      //                     }
      //
      //
      //                   },
      //                   child: Text(
      //                     "Sign In",
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 18,
      //                       fontFamily: 'Poppins-Medium.ttf',
      //                     ),
      //                     textAlign: TextAlign.center,
      //                   ),
      //                   color: Color(0xFFBC1F26),
      //                   shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0), side: BorderSide(color: Color(0xFFBC1F26))),
      //                 ),
      //                 decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
      //               ),
      //               SizedBox(height: 12.0),
      //               Text(
      //                 error,
      //                 style: TextStyle(color: Colors.red),
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Container(
      //                 width: double.infinity,
      //                 child: Column(
      //                   children: <Widget>[
      //                     SignInButton(
      //                       Buttons.Facebook,
      //                       onPressed: () => _auth.loginFacebook(),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //
      //                       Flexible(
      //                       flex: 1,
      //                       child: Align(
      //                       alignment: Alignment.bottomCenter,
      //                       child: Row(
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: <Widget>[
      //                       Container(
      //                       child: Text(
      //                       "Don't have an account? ",
      //                       style: TextStyle(
      //                       color: Color(0xFF666666),
      //                       fontFamily: defaultFontFamily,
      //                       fontSize: defaultFontSize,
      //                       fontStyle: FontStyle.normal,
      //                           ),
      //                         ),
      //                       ),
      //                       InkWell(
      //                         onTap: () => {
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(builder: (context) => registration()),
      //                           )
      //                         },
      //                         child: Container(
      //                           child: Text(
      //                             "Sign Up",
      //                             style: TextStyle(
      //                               color: Color(0xFFAC252B),
      //                               fontFamily: defaultFontFamily,
      //                               fontSize: defaultFontSize,
      //                               fontStyle: FontStyle.normal,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //
      //                     ],
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

    );
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}


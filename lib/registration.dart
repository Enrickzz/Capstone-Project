import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/patient_list/doctor_patient_list.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'dialogs/policy_dialog.dart';
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
  String confirmpassword = '';
  List<String> connection = ["NA", "NA"];
  bool isFirstTime = true;
  bool checkboxValue = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isHidden = true;
  bool _isCHidden = true;
  bool isDoctor = false;


  //added by borj
  String valueChooseUserStatus;
  List<String> listUserStatus = <String>[
    'Patient', 'Doctor', 'Family member / Caregiver'
  ];
  String valueChooseDoctorKind = "Cardiologist";
  List<String> listDoctorKind = <String>[
    'Cardiologist', 'Allergists/Immunologist',
    'Anesthesiologist', 'Colon and Rectal Surgeon',
    'Critical Care Medicine Specialist',
    'Dermatologist','Endocrinologist',
    'Emergency Medicine Specialist',
    'Family Physician','Gastroenterologist',
    'Geriatric Medicine Specialist',
    'Hematologist','Hospice and Palliative Medicine Specialist',
    'Infectious Disease Specialist',
    'Internist','Medical Geneticist',
    'Nephrologist','Neurologist','Obstetrician/Gynecologist',
    'Oncologist','Ophthalmologist','Osteopath','Otolaryngologist',
    'Pathologist','Pediatrician','Physiatrist','Plastic Surgeon','Podiatrist'
    'Preventive Medicine Specialist','Psychiatrist','Pulmonologist','Radiologist',
    'Rheumatologist','Urologist'
  ];



  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.only(top: 60.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ),

            ),
            SizedBox(height: 40.0),
            Container(

              alignment: Alignment.topLeft,
              child:  Text( "Create Account,", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(

              alignment: Alignment.topLeft,
              child:  Text( "Sign up to get started!", style: TextStyle( color: Colors.grey, ),
              ),
            ),
            Container(

                child: Column(
                  children: [
                    SizedBox(height: 15.0),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
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
                                      fillColor: Color(0xFFF2F3F5),
                                      hintStyle: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: defaultFontFamily,
                                          fontSize: defaultFontSize),
                                      hintText: "First Name *",
                                    ),
                                    validator: (val) => val.isEmpty ? 'Enter First Name' : null,
                                    onChanged: (val){
                                      setState(() => firstname = val);
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
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
                                      fillColor: Color(0xFFF2F3F5),
                                      hintStyle: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: defaultFontFamily,
                                          fontSize: defaultFontSize),
                                      hintText: "Last Name *",
                                    ),
                                    validator: (val) => val.isEmpty ? 'Enter Last Name' : null,
                                    onChanged: (val){
                                      setState(() => lastname = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
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
                                validator: (val) => val.length < 6 ? 'Minimum password length should be 6 characters' : null,
                                onChanged: (val){
                                  setState(() => password = val);
                                },
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              child: TextFormField(
                                obscureText: _isCHidden,
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
                                    onTap: _toggleCPassword,
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
                                  hintText: "Confirm Password *",
                                ),
                                validator: (val) {
                                  if(val.isEmpty)
                                    return 'Enter Confirm Password';
                                  if(val != password)
                                    return 'Passwords Do Not Match';
                                  return null;
                                },
                                onChanged: (val){
                                  setState(() => confirmpassword = val);
                                },
                              ),
                            ),
                            SizedBox(height: 8.0),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width:0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF2F3F5),
                                hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                    fontFamily: defaultFontFamily,
                                    fontSize: defaultFontSize),
                                hintText: "I am a: *",
                              ),
                              isExpanded: true,
                              value: valueChooseUserStatus,
                              onChanged: (newValue){
                                setState(() {
                                  valueChooseUserStatus = newValue;
                                  print(valueChooseUserStatus);
                                  if(valueChooseUserStatus == "Doctor"){
                                    isDoctor = true;
                                  }
                                  else{
                                    isDoctor = false;
                                  }
                                });
                              },
                              items: listUserStatus.map((valueItem){
                                return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem)
                                );
                              },
                              ).toList(),
                            ),
                            SizedBox(height: 8.0),
                            Visibility(
                              visible: isDoctor,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width:0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF2F3F5),
                                  hintStyle: TextStyle(
                                      color: Color(0xFF666666),
                                      fontFamily: defaultFontFamily,
                                      fontSize: defaultFontSize),
                                  hintText: "My Specialization is: *",
                                ),
                                isExpanded: true,
                                value: valueChooseDoctorKind,
                                onChanged: (newValue){
                                  setState(() {
                                    valueChooseDoctorKind = newValue;
                                    print(valueChooseDoctorKind);


                                  });
                                },
                                items: listDoctorKind.map((valueItem2){
                                  return DropdownMenuItem(
                                      value: valueItem2,
                                      child: Text(valueItem2)
                                  );
                                },
                                ).toList(),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            FormField<bool>(
                              builder: (state) {
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            value: checkboxValue,
                                            onChanged: (bool b) {
                                              setState(() {
                                                checkboxValue = b;
                                              });
                                            }),
                                        Text.rich(
                                          TextSpan(
                                              children: [
                                                TextSpan(text: "I have read and accept the "),
                                                TextSpan(
                                                  text: 'Terms of Service \n',
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return PolicyDialog(
                                                              mdFileName: 'terms_and_conditions.md',
                                                            );
                                                          });
                                                    },
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                                ),
                                                TextSpan(text: "and "),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return PolicyDialog(
                                                              mdFileName: 'privacy_policy.md',
                                                        );
                                                      });
                                                    },
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                                ),
                                              ]
                                          )
                                        )
                                      ],
                                    ),

                                    Container(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.errorText ?? '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                      ),
                                    )
                                  ],
                                );
                              },
                              validator: (value) {
                                if (!checkboxValue) {
                                  return 'You need to accept the Terms of Service and Privacy Policy.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 18.0),
                            Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(minimumSize: Size(220, 0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                onPressed: () async{
                                  if(_formKey.currentState.validate()){
                                    dynamic result = await _auth.registerUser(lastname, firstname, email,password);
                                    if(result == null){
                                      setState(() => error = 'Sign Up Failed');
                                    }else{
                                      setState(() => error = '');
                                    }
                                  }
                                  try{
                                    final User user = auth.currentUser;
                                    final uid = user.uid;
                                    final usersRef = databaseReference.child('users/' + uid + '/personal_info');


                                    if(valueChooseUserStatus == "Patient"){
                                      if(isFirstTime){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => set_up()),
                                        );
                                        isFirstTime = true;
                                        await usersRef.set({"uid": uid.toString(), "firstname": firstname.toString(), "lastname": lastname.toString(), "email": email.toString(), "password": password.toString(), "isFirstTime": isFirstTime.toString(), "userType": valueChooseUserStatus.toString(), "connections": connection});
                                      }
                                    }
                                    else{
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => PatientList()),
                                      );
                                      isFirstTime = false;
                                      await usersRef.set({"uid": uid.toString(), "firstname": firstname.toString(), "lastname": lastname.toString(), "email": email.toString(), "password": password.toString(), "isFirstTime": isFirstTime.toString(), "userType": valueChooseUserStatus.toString(), "connections": connection});
                                    }
                                    print("user registered Sucessfully!");
                                  } catch(e) {
                                    print("you got an error! $e");
                                  }

                                },
                              ),
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
                        )
                    ),
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10,20,10,20),
              child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Sign In',
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              Navigator.pop(context);
                            },
                          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                        ),
                      ]
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  void _toggleCPassword() {
    setState(() {
      _isCHidden = !_isCHidden;
    });
  }
}


import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:my_app/continue_facebook.dart';
import 'package:my_app/continue_google.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/patient_list/doctor/doctor_patient_list.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:flutter/gestures.dart';
import 'dialogs/policy_dialog.dart';
import 'package:crypto/crypto.dart';

import 'patient_list/support_system/suppsystem_patient_list.dart';
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
  String contactnumber = '';
  // List<String> connections = ["NA", "NA"];
  // Connection connectionP = new Connection(uid: "NA", dashboard: false, nonhealth: false, health: false);
  // Connection connectionD = new Connection(uid: "NA", medpres: false, foodplan: false, explan: false, vitals: false);
  bool isFirstTime = true;
  bool checkboxValue = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isHidden = true;
  bool _isCHidden = true;
  bool isDoctor = false;
  bool isSupportSystem = false;


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
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;

  @override
  void initState(){
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _scrollController = ScrollController();
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
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
              SizedBox(height: 35.0),
              Container(

                alignment: Alignment.topLeft,
                child:  Text( "Create Account,", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                validator: (value) => value == null
                                    ? 'Please fill in your user type' : null,
                                onChanged: (newValue){
                                  setState(() {
                                    valueChooseUserStatus = newValue;
                                    print(valueChooseUserStatus);
                                    if(valueChooseUserStatus == "Doctor"){
                                      isDoctor = true;
                                      isSupportSystem = false;
                                    }
                                    else if(valueChooseUserStatus == "Family member / Caregiver"){
                                      isDoctor = false;
                                      isSupportSystem = true;
                                    }
                                    else{
                                      isDoctor = false;
                                      isSupportSystem = false;
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
                                visible: isSupportSystem,
                                  child: TextFormField(
                                    showCursor: true,
                                    keyboardType: TextInputType.number,
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
                                      hintText: "Contact Number *",
                                    ),
                                    validator: (val) => val.isEmpty ? 'Enter Contact Number' : null,
                                    onChanged: (val){
                                      setState(() => contactnumber = val);
                                    },
                                  ),

                              ),
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
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
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
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
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
                                        addtoNotifs("Welcome to Heartistant your personal application for managing your CVD condition. Please feel free to explore the application on your way to a healthier lifestyle!",
                                            "Welcome!",
                                            "1");
                                        if(isFirstTime){
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => set_up()),
                                          );
                                          isFirstTime = true;
                                          password = sha256.convert(utf8.encode(password)).toString();

                                          await usersRef.set({"uid": uid.toString(), "firstname": firstname.toString(), "lastname": lastname.toString(),
                                            "email": email.toString(), "password": password.toString(), "isFirstTime": isFirstTime.toString(), "userType": valueChooseUserStatus.toString(), "pp_img": "assets/images/blank_person.png"});
                                          final fitbitRef = databaseReference.child('users/' + uid + '/fitbit_connection/');
                                          fitbitRef.update({"isConnected": "false"});
                                          final idRef = databaseReference.child('patient_ids/');
                                          await idRef.once().then((DataSnapshot snapshot) {
                                            print(snapshot.value);
                                            List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                                            if(temp == null){
                                              idRef.child("/"+0.toString()).set({"id": uid.toString()});
                                            }else{
                                              List<PatientIds> plist=[];
                                              temp.forEach((jsonString) {
                                                plist.add(PatientIds.fromJson(jsonString));
                                              });
                                              idRef.child("/"+plist.length.toString()).set({"id": uid.toString()});
                                            }
                                            print(temp);
                                          });

                                        }
                                      }
                                      else if(valueChooseUserStatus == 'Family member / Caregiver'){
                                        addtoNotifs("Welcome to Heartistant your personal application for managing your CVD condition. Please feel free to explore the application and add a patient under your care list",
                                            "Welcome!",
                                            "1");
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => PatientListSupportSystemView()),
                                        );
                                        isFirstTime = false;
                                        password = sha256.convert(utf8.encode(password)).toString();
                                        await usersRef.set({"uid": uid.toString(), "firstname": firstname.toString(), "lastname": lastname.toString(), "email": email.toString(), "password": password.toString(), "isFirstTime": isFirstTime.toString(), "userType": valueChooseUserStatus.toString()});
                                      }
                                      else{
                                        addtoNotifs("Welcome to Heartistant your personal application for managing your CVD condition. Please feel free to explore the application and add a patient under your care list",
                                            "Welcome!",
                                            "1");
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => PatientList()),
                                        );
                                        isFirstTime = false;
                                        password = sha256.convert(utf8.encode(password)).toString();
                                        await usersRef.set({"uid": uid.toString(), "firstname": firstname.toString(), "lastname": lastname.toString(), "email": email.toString(), "password": password.toString(), "isFirstTime": isFirstTime.toString(), "userType": valueChooseUserStatus.toString(), "specialty": valueChooseDoctorKind});
                                      }
                                      print("user registered Sucessfully!");
                                    } catch(e) {
                                      print("you got an error! $e");
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
                                      onPressed: () {
                                        showModalBottomSheet(context: context,
                                          isScrollControlled: true,
                                          builder: (context) => SingleChildScrollView(child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: continue_facebook(),
                                          ),
                                          ),
                                        );

                                        // return _auth.loginFacebook();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.grey,
                                  minimumSize: Size(220, 40),
                                  elevation: 3,
                                    side: BorderSide(width: 0.8, color: Colors.black,)
                                ),
                                  icon: new Image.network(
                                    'http://pngimg.com/uploads/google/google_PNG19635.png', width: 30,
                                    fit:BoxFit.cover,
                                  ),
                                  label: Text("Sign up with Google",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6)),),

                                onPressed: (){

                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: continue_google(),
                                    ),
                                    ),
                                  );


                                },
                              ),
                              SizedBox(height: 15.0),
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
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                          ),
                        ]
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void addtoNotifs(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    String redirect= "";
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "welcome", "redirect": redirect});
      }
    });
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


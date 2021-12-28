import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'dialogs/policy_dialog.dart';
import 'fitness_app_theme.dart';
import 'models/users.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DoctorAddPatient(title: 'Flutter Demo Home Page'),
    );
  }
}

class DoctorAddPatient extends StatefulWidget {
  DoctorAddPatient({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DoctorAddPatientState createState() => _DoctorAddPatientState();
}
final FirebaseAuth auth = FirebaseAuth.instance;
class _DoctorAddPatientState extends State<DoctorAddPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  String userUID = "";
  Users user = new Users();


  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: const Text('Search for Patient', style: TextStyle(
                color: Colors.black
            )),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction, key: _formKey,
                      child: Row (
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Input access code here',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                                  filled: true,
                                  errorStyle: TextStyle(fontSize: 15),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                                ),
                                onChanged: (val) {
                                  userUID = val;

                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Text('Search', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                print(userUID);
                                getPatient(userUID);
                              },
                            ),
                          ]
                      )),
                )
            ),
          ),
          body:  Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 2, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                                  ],
                                ),
                                child: Icon(Icons.person_outlined, size: 50, color: Colors.blue,),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('DisplayName',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          // color:Color(0xFF363f93),
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('email',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    // color:Color(0xFF363f93),
                                                  )
                                              )
                                            ]
                                        )
                                    ),
                                  ],
                                )
                            )
                          ]
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Row(
                                children:<Widget>[
                                  Expanded(
                                    child: Text("Search for Patient",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:Color(0xFF4A6572),
                                        )
                                    ),
                                  ),
                                  InkWell(
                                      highlightColor: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      onTap: () {},
                                      child: Row(
                                        children: <Widget>[
                                          Text("Add Patient",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color:Color(0xFF2633C5),
                                              )
                                          ),
                                        ],
                                      )
                                  )
                                ]
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                              height: 380,
                              child: Stack(
                                  children: [
                                    Positioned(
                                        child: Material(
                                          child: Center(
                                            child: Container(
                                                width: 340,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        blurRadius: 20.0)],
                                                )
                                            ),
                                          ),
                                        )),
                                    Positioned(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Complete Name",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text('DisplayName',
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text("Birthday",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text( 'mm/dd/yyyy',
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text("Age",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text( "X years old",
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text("Gender",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text('M/F/?',
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text("CVD Condition",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text("xxxxxxx",
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text("Other Condition",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text("xxxxxxx",
                                                    style: TextStyle(
                                                        fontSize:16,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        ))
                                  ]
                              )
                          ),
                        ],
                      ),

                    ]
                )
            ),

          )
      ),

    );


  }
// Widget buildCopy() => Row(children: [
//   TextField(controller: controller),
//   IconButton(
//       icon: Icon(Icons.content_copy),
//       onPressed: (){
//         FlutterClipboard.copy(text);
//       },
//   )
//
// ],)
  void getPatient(String uid) {
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final readUID = databaseReference.child('users/');
    final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
    readUID.once().then((DataSnapshot snapshot){
      var temp = snapshot.value;
      print(temp);
      for(int i = 0; i < temp.length; i++){
        if(uid == temp[i]){
          readPatient.once().then((DataSnapshot snapshot){
            user = snapshot.value;
            print(user.firstname + " " + user.lastname);
          });
        }
      }

    });
  }
}


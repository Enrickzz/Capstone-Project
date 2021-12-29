import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
import 'package:my_app/my_diary/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';

import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:my_app/notifications.dart';
import 'package:my_app/patient_view_support_system.dart';
import 'package:my_app/data_inputs/medication_prescription.dart';
import 'package:my_app/view_medical_prescription_as_patient.dart';
import 'package:my_app/management_plan_doctor_view.dart';
import 'package:video_player/video_player.dart';



class view_patient_profile extends StatefulWidget {
  const view_patient_profile({Key key, this.animationController, this.patientUID}) : super(key: key);
  final String patientUID;
  final AnimationController animationController;
  @override
  _index3State createState() => _index3State();
}

class _index3State extends State<view_patient_profile>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  double topBarOpacity = 0.0;
  Users profile = new Users();
  String DisplayName = " ";
  String email = " ";
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateTime birthdate;
  final test = DateTime(1999, 5, 18); // for test
  int age = 0;
  String gender = "";
  double weight = 0;
  double height = 0;
  String bday ="";
  Additional_Info info;
  Additional_Info disease;
  Additional_Info allergies;
  Additional_Info other_info;
  String disease_name = "";
  String family_disease = "";
  String other_disease = "";
  String food_aller = "";
  String drug_aller = "";
  String other_aller = "";
  String ave_sticks = "";
  String alcohol_freq = "";
  String lifestyle = "";



  @override
  void initState() {
    super.initState();
    info = new Additional_Info(bmi: 0, birthday: format.parse("01/01/0000"), gender: "Male", height: 0, weight: 0);
    String patientuid = widget.patientUID;
    getProfile(patientuid);
    getInfo(patientuid);
    // getDisease(patientuid);
    // getAllergies(patientuid);
    // getOtherInfo(patientuid);
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     print("FULL SET STATE");
    //   });
    // });

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
            title: Text(DisplayName + "'s Profile", style: TextStyle(
                color: Colors.black
            )),
            centerTitle: true,
            backgroundColor: Colors.white,
            // actions: [
            //   Container(
            //     margin: EdgeInsets.only( top: 16, right: 16,),
            //     child: Stack(
            //       children: <Widget>[
            //         Icon(Icons.notifications, ),
            //         Positioned(
            //           right: 0,
            //           child: Container(
            //             padding: EdgeInsets.all(1),
            //             decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
            //             constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
            //             child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
            //           ),
            //         )
            //       ],
            //     ),
            //   )
            // ],

          ),
          body: Scrollbar(
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
                                  Text(DisplayName,
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
                                            Text(email,
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
                                  child: Text("Personal Information",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),

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
                                                Text(DisplayName,
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
                                                Text( info.birthday.month.toString() + "/" + info.birthday.day.toString() + "/" + info.birthday.year.toString(),
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
                                                Text(getAge(info.birthday) + " years old",
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
                                                Text(info.gender,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text("Weight",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(info.weight.toString() + " kg",
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text("Height",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(info.height.toString() + " cm",
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
                    ),  // Personal Information

                    SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Medical History",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),

                              ]
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                            height: 200,
                            // height: 500, if may contact number and email
                            // margin: EdgeInsets.only(bottom: 50),
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
                                                Text("Disease",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(disease_name,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Text("Comorbidities",
                                                      style: TextStyle(
                                                        fontSize:14,
                                                        color:Color(0xFF363f93),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(other_disease,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text("Family History",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(family_disease,
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
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Allergies",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),

                              ]
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                            height: 200,
                            // height: 500, if may contact number and email
                            // margin: EdgeInsets.only(bottom: 50),
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
                                                Text("Food Allergies",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(food_aller,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Text("Drug Allergies",
                                                      style: TextStyle(
                                                        fontSize:14,
                                                        color:Color(0xFF363f93),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(drug_aller,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text("Other Allergies",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(other_aller,
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
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Other Information",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),

                              ]
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                            height: 200,
                            // height: 500, if may contact number and email
                            // margin: EdgeInsets.only(bottom: 50),
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
                                                Text("Lifestyle",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(lifestyle,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Text("Smoking",
                                                      style: TextStyle(
                                                        fontSize:14,
                                                        color:Color(0xFF363f93),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(ave_sticks,
                                                  style: TextStyle(
                                                      fontSize:16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text("Alcohol Drinking Frequency",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(alcohol_freq,
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
                    ),// Health Informati// Health Information
                    SizedBox(height: 30),
                    Container(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Personal Information"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap:(){

                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                title: Text("Medical History"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap:(){

                                },
                              ),
                              _buildDivider(),
                              // ListTile(
                              //   title: Text("Doctors' Prescriptions"),
                              //   trailing: Icon(Icons.keyboard_arrow_right),
                              //   onTap:(){
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) => medication_prescription()),
                              //     );
                              //
                              //   },
                              // ),
                              ListTile(
                                title: Text("Doctors' Orders"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => management_plan()),
                                  );

                                },
                              ),

                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 20.0)],
                        )
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('View Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        onPressed: () async {

                        },
                      ),
                    ),

                  ]
              ),


            ),
          ),

        )
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }



  // Widget getAppBarUI() {
  //   return Column(
  //     children: <Widget>[
  //       AnimatedBuilder(
  //         animation: widget.animationController,
  //         builder: (BuildContext context, Widget child) {
  //           return FadeTransition(
  //             opacity: topBarAnimation,
  //             child: Transform(
  //               transform: Matrix4.translationValues(
  //                   0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: FitnessAppTheme.white.withOpacity(topBarOpacity),
  //                   borderRadius: const BorderRadius.only(
  //                     bottomLeft: Radius.circular(32.0),
  //                   ),
  //                   boxShadow: <BoxShadow>[
  //                     BoxShadow(
  //                         color: FitnessAppTheme.grey
  //                             .withOpacity(0.4 * topBarOpacity),
  //                         offset: const Offset(1.1, 1.1),
  //                         blurRadius: 10.0),
  //                   ],
  //                 ),
  //
  //               ),
  //             ),
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }
  String formatDate (String date) {
    return format.parse(date).toString();
  }
  String getAge (DateTime birthday) {
    DateTime today = new DateTime.now();
    String days1 = "";
    String month1 = "";
    String year1 = "";
    int d = int.parse(DateFormat("dd").format(birthday));
    int m = int.parse(DateFormat("MM").format(birthday));
    int y = int.parse(DateFormat("yyyy").format(birthday));
    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    int age = 0;
    age = y1 - y;
    print(age);

    // dec < jan
    if(m1 < m){
      print("month --");
      age--;
    }
    else if (m1 == m){
      if(d1 < d){
        print("day --");
        age--;
      }
    }
    return age.toString();
  }
  void addAllListData() {
    const int count = 5;

    listViews.add(
      GridImages(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

  }

// Future<bool> getData() async {
//   await Future<dynamic>.delayed(const Duration(milliseconds: 50));
//   return true;
// }
  void getProfile(String uid) {
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        profile = Users.fromJson(temp);
      });
      DisplayName = profile.firstname + " " + profile.lastname;
      email = profile.email;
    });
  }
  void getInfo(String uid) {
    final readInfo = databaseReference.child('users/' + uid + '/vitals/additional_info/');
    readInfo.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        info = Additional_Info.fromJson5(temp);
      });
      ave_sticks = info.average_stick.toString();
      alcohol_freq = info.alcohol_freq;
      lifestyle = info.lifestyle;
      /// disease name
      if(info.disease[0] != "NA"){
        for(int j = 0; j < info.disease.length; j++){
          if(j == info.disease.length - 1){
            disease_name += info.disease[j];
          }
          else{
            disease_name += info.disease[j] + ", ";
          }
        }
      }

      /// family disease name
      if(info.family_disease[0] != "NA"){
        for(int j = 0; j < info.family_disease.length; j++){
          if(j == info.family_disease.length - 1){
            family_disease += info.family_disease[j];
          }
          else{
            family_disease += info.family_disease[j] + ", ";
          }
        }
      }

      /// other disease name
      if(info.other_disease[0] != "NA"){
        for(int j = 0; j < info.other_disease.length; j++){
          if(j == info.other_disease.length - 1){
            other_disease += info.other_disease[j];
          }
          else{
            other_disease += info.other_disease[j] + ", ";
          }
        }
      }

      /// food allergies
      if(info.foodAller[0] != "NA"){
        if(info.foodAller.length == 1){
          food_aller += info.foodAller[0];
        }
        else{
          for(int j = 0; j < info.foodAller.length; j++){
            if(j == info.foodAller.length - 1){
              food_aller += info.foodAller[j];
            }
            else{
              food_aller += info.foodAller[j] + ", ";
            }
          }
        }
      }

      /// drug allergies
      if(info.drugAller[0] != "NA"){
        if(info.drugAller.length == 1){
          drug_aller += info.drugAller[0];
        }
        else{
          for(int j = 0; j < info.drugAller.length; j++){
            if(j == info.drugAller.length - 1){
              drug_aller += info.drugAller[j];
            }
            else{
              drug_aller += info.drugAller[j] + ", ";
            }
          }
        }
      }

      /// other allergies
      if(info.otherAller[0] != "NA"){
        if(info.otherAller.length == 1){
          other_aller += info.otherAller[0];
        }
        else{
          for(int j = 0; j < info.otherAller.length; j++){
            if(j == info.otherAller.length - 1){
              other_aller += info.otherAller[j];
            }
            else{
              other_aller += info.otherAller[j] + ", ";
            }
          }
        }
      }



    });
  }

}

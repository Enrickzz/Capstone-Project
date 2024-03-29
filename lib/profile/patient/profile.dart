import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:my_app/distress_call_logs/patient%20or%20support_system/view_call_log_as_support.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/profile/patient/edit_status.dart';
import 'package:my_app/profile/patient/edit_allergies.dart';
import 'package:my_app/profile/patient/edit_medical_history.dart';
import 'package:my_app/profile/patient/edit_other_information.dart';
import 'package:my_app/profile/patient/edit_personal_information.dart';
import 'package:my_app/profile/patient/patient_view_support_list.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/support_system_journal/patient_or_doctor/journal_list_patient_view.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';
import '../../main.dart';
import '../../notifications/notifications._patients.dart';
import 'package:my_app/management_plan/management_plan_patient_view.dart';

import 'add_image.dart';




class index3 extends StatefulWidget {
  const index3({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  _index3State createState() => _index3State();
}

class _index3State extends State<index3>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  double topBarOpacity = 0.0;
  Users profile = new Users();
  String DisplayName = " ";
  String email = "";
  String pp_img = "";
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateTime birthdate;
  final test = DateTime(1999, 5, 18); // for test
  Physical_Parameters param;
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
  bool isLoading = true;
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String bday= "";
  String date;
  String hours,min;
  int lengFin=0;
  List<Connection> connections = new List<Connection>();
  Users thisuser = new Users();
  String password = '';
  bool _isHidden = true;
  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;
  List<distressSOS> SOS = new List<distressSOS>();
  int lengSOS = 0;

  @override
  void initState() {
    super.initState();
    initNotif();
    getNotifs();getRecomm();
    info = new Additional_Info(birthday: format.parse("01/01/0000"), gender: "Male");
    getProfile();
    getInfo();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        bday = info.birthday.month.toString() + "/" + info.birthday.day.toString() + "/" + info.birthday.year.toString();
        isLoading = false;
        print("setstate");
      });
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


    return  Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Profile', style: TextStyle(
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
          actions: [
            GestureDetector(
                onTap: () async {
                  final User user = auth.currentUser;
                  final uid = user.uid;
                  final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
                  Users patient = new Users();
                  String contactNum="";
                  String contactNumFName = "";
                  String contactNumLName = "";
                  await readPatient.once().then((DataSnapshot snapshotPatient) {
                    Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
                    patientTemp.forEach((key, jsonString) {
                      patient = Users.fromJson(patientTemp);
                    });
                  }).then((value) async {
                    if(patient.emergency_contact == null){
                      await FlutterPhoneDirectCaller.callNumber("911").then((value) {
                        notifySS();
                      });
                      final readSOS = databaseReference.child('users/' + uid + '/SOSCalls/');
                      readSOS.once().then((DataSnapshot snapshot) async {
                        if (snapshot.value == null) {
                          final ref = databaseReference.child(
                              'users/' + uid + '/SOSCalls/' + 0.toString());
                          ref.set({
                            "full_name": " ",
                            "rec_date": date,
                            "rec_time": "$hours:$min",
                            "reason": "", "number": "911",
                            "note": "",
                            "call_desc": "",
                          });
                        }
                        else{
                          getSOS().then((value) {
                            final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + lengSOS.toString());
                            ref.set({
                              "full_name": " ",
                              "rec_date": date,
                              "rec_time": "$hours:$min",
                              "reason": "","number": "911",
                              "note": "",
                              "call_desc": "",
                            });
                          });
                        }
                      });
                    }else{
                      final readContactNum = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/contact_no/' /** contact_number ni SS*/);
                      final readContactLNumName = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/lastname/' /** last name ni SS*/);
                      final readContactFNumName = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/firstname/' /** first name ni SS*/);
                      await readContactNum.once().then((DataSnapshot contact) {
                        readContactLNumName.once().then((DataSnapshot lastname) {
                          contactNumLName = lastname.value.toString();
                        });
                        readContactFNumName.once().then((DataSnapshot firstname) {
                          contactNumFName = firstname.value.toString();
                        });
                        contactNum = contact.value.toString();
                      }).then((value) async{
                        print(">>>YAY");
                        await FlutterPhoneDirectCaller.callNumber(contactNum).then((value) {
                          notifySS();
                        });
                        final readSOS = databaseReference.child('users/' + uid + '/SOSCalls/');
                        readSOS.once().then((DataSnapshot snapshot) async {
                          if (snapshot.value == null) {
                            final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + 0.toString());
                            ref.set({
                              "full_name": "$contactNumFName $contactNumLName",
                              "rec_date": date,
                              "rec_time": "$hours:$min",
                              "reason": "","number": contactNum,
                              "note": "",
                              "call_desc": "",
                            });
                          } else {
                            getSOS().then((value) {
                              final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + lengSOS.toString());
                              ref.set({
                                "full_name": "$contactNumFName $contactNumLName",
                                "rec_date": date,
                                "rec_time": "$hours:$min",
                                "reason": "","number": contactNum,
                                "note": "",
                                "call_desc": "",
                              });
                            });
                          }
                        });
                      });
                    }
                  });

                },
                child: Image.asset(
                  'assets/images/emergency.png',
                  width: 32,
                  height: 32,
                )
            ),
            SizedBox(width: 24),
            Container(
              margin: EdgeInsets.only( top: 16, right: 16,),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => notifications(animationController: widget.animationController)),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Icon(Icons.notifications, ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: checkNotifs(),
                        constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                        child: Text( '!', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new Scrollbar(
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.white),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                          ],
                        ),

                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => addImage(img: pp_img)),
                                );
                            },

                          child: ClipOval(
                            child: checkimage(pp_img)),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(DisplayName,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    // color:Color(0xFF363f93),
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
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
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(context: context,
                                      isScrollControlled: true,
                                      builder: (context) => SingleChildScrollView(child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: edit_status(status: profile.status),
                                      ),
                                      ),
                                    ).then((value) {
                                      if(value != null){
                                        // profile.status = value;
                                        setState(() {
                                          print("STATUS = " + value.toString());
                                          profile.status = value;
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(width: 2),
                                              if(profile.status == "Active")...[
                                                Image.asset(
                                                  'assets/images/active.png',
                                                  width: 9,
                                                  height: 9,
                                                ),
                                                SizedBox(width: 4),
                                                Text(profile.status,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:Color(0xFF2633C5),
                                                    )
                                                ),
                                                SizedBox(width: 2),
                                              ] else if(profile.status == "Hospitalized")... [
                                                Image.asset(
                                                  'assets/images/hospitalized.png',
                                                  width: 9,
                                                  height: 9,
                                                ),
                                                SizedBox(width: 4),
                                                Text(profile.status,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:Color(0xFF2633C5),
                                                    )
                                                ),
                                                SizedBox(width: 2),
                                              ] else...[
                                                Image.asset(
                                                  'assets/images/inactive.png',
                                                  width: 9,
                                                  height: 9,
                                                ),
                                                SizedBox(width: 4),
                                                Text(profile.status,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:Color(0xFF2633C5),
                                                    )
                                                ),
                                                SizedBox(width: 2),
                                              ],


                                            ]
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: GestureDetector(
                                      onTap: () async {
                                        showPatientStatusLegend();

                                      },
                                      child: Image.asset(
                                        "assets/images/tite.png",
                                        width: 12,
                                        height: 12,
                                      )
                                  ),
                                ),
                              ],
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
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: edit_personal_information(),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 800), (){
                                        setState((){
                                          if(value != null){
                                            infoChanged newPI = value;
                                            DisplayName = newPI.firstname + " " + newPI.lastname;
                                            bday = newPI.birthDateInString;
                                            param.weight = double.parse(newPI.weight.toString());
                                            param.height = double.parse(newPI.height.toString());
                                          }
                                        });
                                      }));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text("Edit",
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
                      width: 340,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [BoxShadow(
                              color: Colors.black26.withOpacity(0.2),
                              offset: Offset(0.0,6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10
                          )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                            Text( bday,
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
                            Text(StringUtils.capitalize(info.gender),
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
                            Text(param.weight.toString() + " kg",
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
                            Text(param.height.toString() + " cm",
                              style: TextStyle(
                                  fontSize:16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => edit_medical_history()),
                                  ).then((value) {
                                    Future.delayed(const Duration(milliseconds: 800), (){
                                      setState((){
                                        if(value != null){
                                          disease_name="";
                                          family_disease='';
                                          other_disease ='';
                                          mdhChanged newMH = value;
                                          info.disease = newMH.disease;
                                          info.other_disease = newMH.other_disease;
                                          info.family_disease = newMH.family_disease;
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
                                        }
                                      });
                                    });
                                  });
                                },
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text( "Edit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color:Color(0xFF2633C5),
                                        )
                                    ),
                                  ],
                                )
                              // )
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: 340,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [BoxShadow(
                              color: Colors.black26.withOpacity(0.2),
                              offset: Offset(0.0,6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10
                          )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("CVD Condition/s",
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
                            Text(other_disease == "" ? 'N/A' : other_disease,
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
                            Text(family_disease == "" ? 'N/A' : family_disease,
                              style: TextStyle(
                                  fontSize:16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => edit_allergies()),
                                  ).then((value) {
                                    Future.delayed(const Duration(milliseconds: 500),(){
                                      setState(() {
                                        allergyChanged newA = value;
                                        food_aller ="";
                                        drug_aller ="";
                                        other_aller = "";
                                        info.foodAller = newA.foodAller;
                                        info.drugAller = newA.drugAller;
                                        info.otherAller = newA.otherAller;
                                        /// food allergies
                                        if(!info.foodAller.contains("NA")){
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
                                        if(!info.drugAller.contains("NA")){
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
                                        if(!info.otherAller.contains("NA")){
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
                                    });
                                  });
                                },
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text( "Edit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color:Color(0xFF2633C5),
                                        )
                                    ),
                                  ],
                                )
                              // )
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: 340,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [BoxShadow(
                              color: Colors.black26.withOpacity(0.2),
                              offset: Offset(0.0,6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10
                          )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Food Allergies",
                              style: TextStyle(
                                fontSize:14,
                                color:Color(0xFF363f93),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(food_aller == "" ? 'N/A' : food_aller,
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
                            Text(drug_aller == "" ? 'N/A' : drug_aller,
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
                            Text(other_aller == "" ? 'N/A' : other_aller,
                              style: TextStyle(
                                  fontSize:16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: edit_other_information(),
                                    ),
                                    ),
                                  ).then((value) => setState((){
                                    if(value != null){
                                      otherChanged newO = value;
                                      Future.delayed(const Duration(milliseconds: 800), (){
                                        setState(() {
                                          if(newO.goal == null || newO.goal == ""){
                                          }else ave_sticks = newO.goal;
                                          if(newO.valueLifestyle == null){
                                          }else lifestyle = newO.valueLifestyle;
                                          if(newO.valueAlc == "null"){
                                          }else alcohol_freq = newO.valueAlc;

                                        });
                                      });
                                    }
                                  }));
                                },
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text( "Edit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color:Color(0xFF2633C5),
                                        )
                                    ),

                                  ],
                                )
                              // )
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),

                    Container(
                      width: 340,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [BoxShadow(
                              color: Colors.black26.withOpacity(0.2),
                              offset: Offset(0.0,6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10
                          )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                Text("Cigarettes per day",
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
                          ],
                        ),
                      ),
                    ),


                  ],
                ),// Health Information
                SizedBox(height: 30),
                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("Manage Healthcare Team"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SupportSystemList()),
                            );

                          },
                        ),

                        _buildDivider(),

                        ListTile(
                          title: Text("Doctors' Orders"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => management_plan_patient_view(animationController: widget.animationController)),
                            );

                          },
                        ),

                        _buildDivider(),
                        ListTile(
                          title: Text("Support Systems' Notes"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap:(){
                            Navigator.push(
                              context,
                              // MaterialPageRoute(builder: (context) => journal_list_supp_view()),
                              MaterialPageRoute(builder: (context) => journal_list_patient_view()),
                            );

                          },
                        ),

                        _buildDivider(),
                        ListTile(
                          title: Text("Distress Call Logs"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => call_log_suppView()),
                            );

                          },
                        ),
                        // _buildDivider(),
                        // ListTile(
                        //   title: Text("Doctors' Discussion Board"),
                        //   trailing: Icon(Icons.keyboard_arrow_right),
                        //   onTap:(){
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => discussion_patient_view()),
                        //     );
                        //
                        //   },
                        // ),
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
                    style: ElevatedButton.styleFrom(minimumSize: Size(160, 0)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text('Sign Out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                      print('signed out');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red, minimumSize: Size(140, 0)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text('Wipe Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      _showMyDialogWipe();
                      // await _auth.signOut();
                      // print('signed out');
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LogIn()),
                      // );
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



  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),

                ),
              ),
            );
          },
        )
      ],
    );
  }
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
  void getProfile() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        profile = Users.fromJson(temp);
      });
      DisplayName = profile.firstname + " " + profile.lastname;
      email = profile.email;
      pp_img = profile.pp_img;
    });
  }
  void getInfo() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readInfo = databaseReference.child('users/' + uid + '/vitals/additional_info/');
    final readParam = databaseReference.child('users/' + uid + '/physical_parameters/');
    readParam.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        param = Physical_Parameters.fromJson(temp);
      });
    });
    readInfo.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print(temp);
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
      if(!info.foodAller.contains("NA")){
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
      if(!info.drugAller.contains("NA")){
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
      if(!info.otherAller.contains("NA")){
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
          print("OTHER ALLER");
          print(other_aller.toString());
        }
      }
    });
  }
  Widget checkimage(String img) {
    if(img == null || img == "assets/images/blank_person.png" || img == ""){
      return Image.asset("assets/images/blank_person.png", width: 70, height: 70,fit: BoxFit.cover);
    }else{
      return Image.network(pp_img,
          width: 70,
          height: 70,
          fit: BoxFit.cover);
    }
  }
  void getRecomm() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Failed!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You have not chosen an Emergency contact'),
              ],
            ),
          ),
        );
      },
    );
  }
  void getNotifs() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  Decoration checkNotifs() {
    if(notifsList.isNotEmpty || recommList.isNotEmpty){
      return BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6));
    }else{
      return BoxDecoration();
    }
  }
  Future<void> showPatientStatusLegend() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Status'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[


                SizedBox(height: 12.0,),

                SizedBox(height: 5,),

                Row(
                  children: [
                    Image.asset(
                      'assets/images/active.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Active',
                    style: TextStyle(color: Color(0xFF388E3C),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                ),
                SizedBox(height: 5,),

                Text('This patient is a regular user of Heartistant who has recorded health and non-health data in the past 6 months',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/hospitalized.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Hospitalized',
                      style: TextStyle(color: Color(0xFFF44336),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],


                ),


                SizedBox(height: 5,),

                Text('This patient is currently hospitalized and would not receive any notifications or recommendations from Heartistant',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/inactive.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Inactive',
                      style: TextStyle(color: Color(0xFF90A4AE),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                ),

                SizedBox(height: 5,),

                Text('This patient is inactive and has not logged in to Heartistant in the past 6 months',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),



              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogWipe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wipe Data'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to wipe all your data from our database permanently? You will not be able to recover them.\n\nEnter your password to confirm.'),
                SizedBox(height: 8.0),
                Form(
                  key: _formKey,
                  child: Container(
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
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  if(password == "password") {
                    //delete data
                    print("PASSWORD TRUE");
                    final User user = auth.currentUser;
                    final uid = user.uid;
                    final d1 = databaseReference.child('users/' + uid + '/vitals/health_records/');
                    final d2 = databaseReference.child('users/' + uid + '/recommendations/');
                    final d3 = databaseReference.child('users/' + uid + '/notifications/');
                    await d1.remove().then((value) {
                      d2.remove().then((value) {
                        d3.remove().then((value) {
                          Navigator.of(context).pop();
                        });
                      });
                    });
                  }
                  else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Incorrect password!')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
  void notifySS(){
    final User user = auth.currentUser;
    final uid = user.uid;
    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readConnections.once().then((DataSnapshot snapshot2) {
      print(snapshot2.value);
      print("CONNECTION");
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
      temp.forEach((jsonString) async {
        connections.add(Connection.fromJson(jsonString)) ;
        Connection a = Connection.fromJson(jsonString);
        print(a.doctor1);
        if(uid != a.doctor1){
          await addtoNotif("Your <type> "+ thisuser.firstname+ " has used his panic button! Check on the patient immediately",
              thisuser.firstname + " used SOS!",
              "3",
              a.doctor1,
              "SOS", "",
              date ,
              hours.toString() +":"+min.toString());
        }
      });
    });
  }
  Future<void> addtoNotif(String message, String title, String priority,String uid, String redirect,String category, String date, String time)async {
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) async{
      int leng = await getNotifs2(uid).then((value) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + lengFin.toString());
          ref.set({"id": lengFin.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }
        return value;
      });

    });
  }
  Future<int> getNotifs2(String passedUid) async {
    notifsList.clear();
    final uid = passedUid;
    List<RecomAndNotif> tempL=[];
    final readBP = databaseReference.child('users/' + passedUid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
        notifsList.add(RecomAndNotif.fromJson(jsonString));
        tempL.add(a);
      });
      notifsList = notifsList.reversed.toList();
    }).then((value) {
      print("LENGFIN = " + lengFin.toString());
      lengFin = tempL.length;
      return tempL.length;
    });
  }
  Future<int> getSOS() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    int count = 0;
    final readBP = databaseReference.child('users/' + uid + '/SOSCalls/');
    await readBP.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        count++;
        SOS.add(distressSOS.fromJson(jsonString));
      });
      lengSOS = count;
      return count;
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }
  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

}



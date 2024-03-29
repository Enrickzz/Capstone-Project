import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_app/patient_list/support_system/suppsystem_patient_list.dart';
import 'package:my_app/services/auth.dart';

import '../../fitness_app_theme.dart';
import '../../models/users.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SupportAddPatient(title: 'Flutter Demo Home Page'),
    );
  }
}

class SupportAddPatient extends StatefulWidget {
  SupportAddPatient({Key key, this.title, this.patients, this.diseaseList}) : super(key: key);
  final List patients;
  final List diseaseList;
  final String title;

  @override
  _DoctorAddPatientState createState() => _DoctorAddPatientState();
}
final FirebaseAuth auth = FirebaseAuth.instance;
class _DoctorAddPatientState extends State<SupportAddPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  DateFormat format = new DateFormat("MM/dd/yyyy");

  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  String userUID = "";
  Users cuser = new Users();
  Users patient = new Users();
  Users doctor = new Users();
  Additional_Info info = new Additional_Info();
  String displayName = "";
  String email = "";
  String bday = "";
  int age = 0;
  String gender = "";
  String cvdCondition = "";
  String otherCondition = "";
  List<Connection> doc_connection = [];
  List<Connection> patient_connection = [];
  Connection docConnection = new Connection(doctor1: "", dashboard: "true", nonhealth: "true", health: "true");
  Connection patientConnection = new Connection(doctor1: "", dashboard: "true", nonhealth: "true", health: "true");
  int pcount = 1;
  int dcount = 1;

  bool searchPatient = false;

  List patients;
  List diseasetemp;

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users support = new Users();

  @override
  void initState() {
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
        support = Users.fromJson(temp);
      });
    });
    patients = widget.patients;
    diseasetemp = widget.diseaseList;
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
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
                                  getRecomm(val);
                                  getNotifs(val);
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
                                getPatient();
                                Future.delayed(const Duration(milliseconds: 2000), (){
                                  setState(() {
                                  });
                                });

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
                                child: ClipOval(
                                  // child:Image.asset("assets/images/blank_person.png",
                                  child: checkimage(cuser.pp_img),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(displayName,
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
                                      onTap: () {
                                        _showMyDialog();
                                      },
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
                                                  Text(displayName,
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
                                                  Text(bday,
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
                                                  Text( age.toString() + " years old",
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
                                                  Text(gender,
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
                                                  Text(cvdCondition,
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
                                                  Text(otherCondition,
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

  void getPatient() async{
    final readPatient = databaseReference.child('users/' + userUID + '/personal_info/');
    final readinfo = databaseReference.child('users/' + userUID + '/vitals/additional_info/');
    cvdCondition = "";
    otherCondition = "";
    await readPatient.once().then((DataSnapshot snapshot){
      var temp = jsonDecode(jsonEncode(snapshot.value));
      cuser = Users.fromJson(temp);
    });
    await readinfo.once().then((DataSnapshot snapshot){
      var temp = jsonDecode(jsonEncode(snapshot.value));
      info = Additional_Info.fromJson3(temp);
    });
    if(cuser.usertype == "Patient"){
      displayName = cuser.firstname;
      displayName += " ";
      displayName += cuser.lastname;
      email = cuser.email;
      bday = "${info.birthday.month}/${info.birthday.day}/${info.birthday.year}";
      age = int.parse(getAge(info.birthday));
      gender = info.gender;
      for(int i = 0; i < info.disease.length; i++){
        if(i == info.disease.length - 1){
          cvdCondition += info.disease[i];
        }
        else{
          cvdCondition += info.disease[i] + ", ";
        }

      }
      for(int i = 0; i < info.other_disease.length; i++){
        if(i == info.other_disease.length - 1){
          otherCondition += info.other_disease[i];
        }
        else{
          otherCondition += info.other_disease[i] + ", ";
        }
      }
    }
    setState(() {
      print("set here");
      searchPatient = true;
    });

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

  void addPatient() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctorConnection = databaseReference.child('users/' + uid + '/personal_info/connections/');
    // final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    final readPatientConnection = databaseReference.child('users/' + userUID + '/personal_info/connections/');
    final readPatient = databaseReference.child('users/' + userUID + '/personal_info/');
    doc_connection.clear();
    patient_connection.clear();
    bool isPatient = false;
    bool isDoctor = false;
    /// read support system connections
    readDoctorConnection.once().then((DataSnapshot datasnapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
      if(datasnapshot.value != null){
        temp.forEach((jsonString) {
          doc_connection.add(Connection.fromJson(jsonString));
        });
        for(int i = 0; i < doc_connection.length; i++){
          if(doc_connection[i].doctor1 == userUID){
            print("same patient detected");
            isPatient = true;
          }
        }
        dcount = doc_connection.length+1;
      }

      /// read patient connections
      readPatientConnection.once().then((DataSnapshot snapshot){
        List<dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        if(snapshot.value != null){
          temp2.forEach((jsonString) {
            patient_connection.add(Connection.fromJson(jsonString));
          });
          for(int i = 0; i < patient_connection.length; i++){
            if(patient_connection[i].doctor1 == uid){
              print("same patient detected");
              isDoctor = true;
            }
          }
          pcount = patient_connection.length+1;
        }
        if(isDoctor == false){
          patientConnection.doctor1 = uid;
          patient_connection.add(patientConnection);
          print("doctor added successfully");
        }
        final addPatientConnection = databaseReference.child('users/' + userUID + '/personal_info/connections/' + pcount.toString());

        addPatientConnection.set({
          "uid": uid,
          "dashboard": "false",
          "nonhealth": "false",
          "health": "false",
          "addedit": "false",
        });
      });

      if(isPatient == false){
        docConnection.doctor1 = userUID;
        doc_connection.add(docConnection);
        print("patient added successfully");
      }

      final addDoctorConnection = databaseReference.child('users/' + uid + '/personal_info/connections/' + dcount.toString());
      addDoctorConnection.set({
        "uid": userUID,
        "dashboard": "false",
        "nonhealth": "false",
        "health": "false",
        "addedit": "false",
      });
      readPatient.once().then((DataSnapshot patientsnapshot){
        Map<String, dynamic> temp = jsonDecode(jsonEncode(patientsnapshot.value));
        print(temp);
        patient = Users.fromJson(temp);
        patients.add(patient);
        if(patient.emergency_contact == null){
          final addEMC = databaseReference.child('users/' + userUID + '/personal_info/');
          addEMC.update({"emergency_contact": uid});
        }
      });

      diseasetemp.add(cvdCondition);

    });
  }

  Widget checkimage(String img) {
    if(img == null || img == "assets/images/blank_person.png"){
      return Image.asset("assets/images/blank_person.png", width: 70, height: 70,fit: BoxFit.cover);
    }else{
      return Image.network(img,
          width: 70,
          height: 70,
          fit: BoxFit.cover);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Add Patient'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure this is the right patient?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                addtoNotif(support.firstname +" "+ support.lastname+ " signed up as a member for of your support system.He/She can now start seeing your personal health data and other aspects of your health management." ,
                    support.lastname + " added you!",
                    "1",
                    "Support System Add",
                    userUID);
                print('Patient Added');
                addPatient();

                Future.delayed(const Duration(milliseconds: 2000), (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PatientListSupportSystemView(patients: patients,diseaselist: diseasetemp)));
                });

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    // getNotifs(uid);
    // print((notifsList.length--).toString() + "<<<< LENG");
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});

      }
    });
  }
  void getNotifs(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void getRecomm(String uid) {
    print("GET RECOM");
    recommList.clear();
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
}


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:my_app/additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'package:my_app/dialogs/policy_dialog.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/edit_medication_prescription.dart';
import 'package:http/http.dart' as http;





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificExercisePrescriptionViewAsPatient(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificExercisePrescriptionViewAsPatient extends StatefulWidget {
  SpecificExercisePrescriptionViewAsPatient({Key key, this.title, this.index, this.thislist}) : super(key: key);
  final List<ExPlan> thislist;
  final String title;
  int index;
  @override
  _SpecificExercisePrescriptionViewAsPatientState createState() => _SpecificExercisePrescriptionViewAsPatientState();
}
List<ExercisesTest> listexercises=[];

class _SpecificExercisePrescriptionViewAsPatientState extends State<SpecificExercisePrescriptionViewAsPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<ExPlan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  String type = "";
  String frequency = "";
  String intensity = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  String exerciselist = "";


  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    // getExplan();
    templist.clear();
    templist = widget.thislist;
    int index = widget.index;
    purpose = templist[index].purpose;
    type = templist[index].type;
    important_notes = templist[index].important_notes ;
    dateCreated = "${templist[index].dateCreated.month}/${templist[index].dateCreated.day}/${templist[index].dateCreated.year}";
    prescribedBy = templist[index].doctor_name;
    getExercises(templist[index].type).then((value) => setState((){
      listexercises=value;
      FocusScope.of(context).requestFocus(FocusNode());
    }));
    for(int i = 0; i < listexercises.length; i++){
      if(listexercises.length != i+1){
        exerciselist += listexercises[i].exerciseName + ", ";
      }
      else{
        exerciselist += listexercises[i].exerciseName;
      }
    }
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print(listexercises[0].exerciseName);
        print("setstate");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Exercise Plan'),
        ),
        body:  Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text( "My Exercise Plan",
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
                        height: 350,
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
                                            Text("Purpose",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(purpose,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Type of exercise",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(type,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            SizedBox(height: 16),
                                            Text("Important Notes/Assessments",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(important_notes,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text("Possible Exercises",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(exerciselist,
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
                    SizedBox(height: 10.0),
                    Container(
                        height: 150,
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
                                            Text("Planned by",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text("Dr." + prescribedBy,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Date Planned",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(dateCreated,
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

              ],
            ),
          ),
        )
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
  void getExplan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExPlan = databaseReference.child('users/' + uid + '/management_plan/exercise_prescription/');
    int index = widget.index;
    readExPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        templist.add(ExPlan.fromJson(jsonString));
      });
      final readDoctorName = databaseReference.child('users/' + templist[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        print(temp2);
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      purpose = templist[index].purpose;
      type = templist[index].type;
      important_notes = templist[index].important_notes ;
      dateCreated = "${templist[index].dateCreated.month}/${templist[index].dateCreated.day}/${templist[index].dateCreated.year}";
    });
  }
  Future<List<ExercisesTest>> getExercises(String query) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExRx = databaseReference.child('ExRxToken/');
    String token = "";
    List<ExercisesTest> exers=[];

    await readExRx.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null || snapshot.value != ""){
        token = snapshot.value.toString();
      }
    });
    var response = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
        headers: {
          'Authorization': "Bearer $token",
        });
    if(response.statusCode == 500 || response.statusCode == 401){
      var trytoken = await http.post(Uri.parse("http://204.235.60.194/consumer/login"),body: {
        "username": "louisexrx",
        "password": "xHj4vNnb"
      });
      token = trytoken.body.toString();
      token = token.replaceAll("{", "").replaceAll("}", "").replaceAll("token", "").replaceAll('"', "").replaceAll(":", "").replaceAll(" ", "").replaceAll("\n", "").replaceAll("/", "");

      var updateexrx = databaseReference;
      print('UPDATING');
      updateexrx.update({"ExRxToken/": token});
      var response1 = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
          headers: {
            'Authorization': "Bearer $token",
          });
      exers = ExRxTest.fromJson(jsonDecode(response1.body)).exercises;
      listexercises= exers;
      return exers;
    }else{
      print("STATUS\n"+response.statusCode.toString());
      var response2 = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
          headers: {
            'Authorization': "Bearer $token",
          });
      exers = ExRxTest.fromJson(jsonDecode(response2.body)).exercises;
      listexercises= exers;
      return exers;
    }
  }
}
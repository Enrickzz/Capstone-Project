import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/management_plan/food_plan/edit_food_prescription.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:my_app/additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'package:my_app/dialogs/policy_dialog.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/edit_medication_prescription.dart';






class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificFoodPrescriptionViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificFoodPrescriptionViewAsDoctor extends StatefulWidget {
  SpecificFoodPrescriptionViewAsDoctor({Key key, this.title, this.userUID, this.index}) : super(key: key);
  final String title;
  String userUID;
  int index;
  @override
  _SpecificFoodPrescriptionViewAsDoctorState createState() => _SpecificFoodPrescriptionViewAsDoctorState();
}

class _SpecificFoodPrescriptionViewAsDoctorState extends State<SpecificFoodPrescriptionViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<FoodPlan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  String food = "";
  String consumption_time = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  bool prescribedDoctor = false;
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;

  @override
  void initState() {
    getRecomm(widget.userUID);
    getNotifs(widget.userUID);
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
        doctor = Users.fromJson(temp);
      });
    });
    templist.clear();
    getFoodplan();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Food Plan'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _showMyDialogDelete();
                      // showModalBottomSheet(context: context,
                      //   isScrollControlled: true,
                      //   builder: (context) => SingleChildScrollView(child: Container(
                      //     padding: EdgeInsets.only(
                      //         bottom: MediaQuery.of(context).viewInsets.bottom),
                      //     child: add_supplement_prescription(thislist: supptemp),
                      //   ),
                      //   ),
                      // ).then((value) =>
                      //     Future.delayed(const Duration(milliseconds: 1500), (){
                      //       setState((){
                      //         print("setstate supplement prescription");
                      //         print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                      //         if(value != null){
                      //           supptemp = value[0];
                      //         }
                      //       });
                      //     }));
                    },
                    child: Icon(
                      Icons.delete,
                    ),
                  )
              ),
            ),
          ],
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
                    Visibility(
                      visible: prescribedDoctor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[
                              Expanded(
                                child: Text( "Food Plan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:Color(0xFF4A6572),
                                    )
                                ),
                              ),
                              Visibility(
                                visible: prescribedDoctor,
                                child: InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    onTap: () {
                                      showModalBottomSheet(context: context,
                                        isScrollControlled: true,
                                        builder: (context) => SingleChildScrollView(child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom),
                                          ///edit food plan
                                          child: edit_food_prescription(userUID: widget.userUID,),
                                        ),
                                        ),
                                      ).then((value) =>
                                          Future.delayed(const Duration(milliseconds: 1500), (){
                                            setState((){
                                              print("setstate medication prescription");
                                              print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                                              if(value != null){
                                                templist = value[0];
                                              }
                                            });
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

                                        // SizedBox(
                                        //   height: 38,
                                        //   width: 26,
                                        //   // child: Icon(
                                        //   //   Icons.arrow_forward,
                                        //   //   color: FitnessAppTheme.darkText,
                                        //   //   size: 18,
                                        //   // ),
                                        // ),
                                      ],
                                    )
                                  // )
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        height: 300,
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
                                                Text("Diet Instructions",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(food,
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
  void getFoodplan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
    int index = widget.index;
    readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        templist.add(FoodPlan.fromJson(jsonString));
      });
      final readDoctorName = databaseReference.child('users/' + templist[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      if(templist[index].prescribedBy == uid){
        prescribedDoctor = true;
      }
      purpose = templist[index].purpose;
      food = templist[index].food;
      important_notes = templist[index].important_notes ;
      dateCreated = "${templist[index].dateCreated.month}/${templist[index].dateCreated.day}/${templist[index].dateCreated.year}";
    });
  }
  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                addtoNotif("Dr. "+doctor.lastname+ " has removed one of your Food management plan. Click here to view your update Food management plan. " ,
                    "Doctor Added to your Food Plan!",
                    "1",
                    "Food Plan",
                    widget.userUID);

                final User user = auth.currentUser;
                final uid = user.uid;
                int initial_length = templist.length;
                templist.removeAt(widget.index);
                // List<int> delete_list = [];
                // for(int i = 0; i < listtemp.length; i++){
                //   if(_selected[i]){
                //     delete_list.add(i);
                //   }
                // }
                // delete_list.sort((a,b) => b.compareTo(a));
                // for(int i = 0; i < delete_list.length; i++){
                //   listtemp.removeAt(delete_list[i]);
                // }
                /// delete fields
                for(int i = 1; i <= initial_length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/foodplan/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < templist.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/foodplan/' + (i+1).toString());
                  bpRef.set({
                    "purpose": templist[i].purpose.toString(),
                    "food": templist[i].food.toString(),
                    "important_notes": templist[i].important_notes.toString(),
                    "prescribedBy": templist[i].prescribedBy.toString(),
                    "datecreated": "${templist[i].dateCreated.month.toString().padLeft(2,"0")}/${templist[i].dateCreated.day.toString().padLeft(2,"0")}/${templist[i].dateCreated.year}",
                  });
                }
                Navigator.of(context).pop();

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


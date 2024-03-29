import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_food_prescription extends StatefulWidget {
  final List<FoodPlan> thislist;
  final String userUID;
  add_food_prescription({this.thislist, this.userUID});
  @override
  _addFoodPrescriptionState createState() => _addFoodPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addFoodPrescriptionState extends State<add_food_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users doctor = new Users();
  Users patient = new Users();
  bool notifier = true;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  // List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  List<FoodPlan> foodplan_list = new List<FoodPlan>();
  String purpose = "";
  String quantity_food = "0";
  String consumption_time = "";
  String important_notes = "";
  String prescribedBy = "";
  DateTime now =  DateTime.now();
  List<String> listFoodTime = <String>[
    'Breakfast', 'Lunch','Dinner', 'Snacks'
  ];
  String valueChooseFoodTime;
  String bp_time;
  String bp_date = (new DateTime.now()).toString();
  String bp_status = "";
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  bool checkboxValue = false;
  String reason_notification = "";

  TextEditingController _nameController;
  static List<String> foodList = [];
  @override
  void initState(){
    foodList.clear();
    foodList.add(null);
    getRecomm(widget.userUID);
    // getNotifs(widget.userUID);
    initNotif();
    Future.delayed(const Duration(milliseconds: 1500),(){
      setState(() {

      });
    });
    super.initState();
    _nameController = TextEditingController();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Add Food Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
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
                      hintText: "Purpose of Plan",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Purpose' : null,
                    onChanged: (val){
                      setState(() => purpose = val);
                    },
                  ),
                  SizedBox(height: 8),
                  ..._getFood(),


                  SizedBox(height: 8.0),

                  TextFormField(
                    maxLines: 6,
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
                      hintText: "Important Notes/Assessments",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Important Notes' : null,
                    onChanged: (val){
                      setState(() => important_notes = val);
                    },
                  ),
                  FormField<bool>(
                    builder: (state) {
                      return Visibility(
                        visible: notifier,
                        child: Column(
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
                                Text("Notify lead doctor"),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: checkboxValue,
                    child: Column(
                      children: [
                        TextFormField(
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
                            hintText: "Reason for notifying",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter reason for notifying' : null,
                          onChanged: (val){
                            setState(() => reason_notification = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            String doctorName = "";
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
                            Users doctor = new Users();
                            readDoctor.once().then((DataSnapshot snapshot) {
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              doctorName = doctor.firstname + " " + doctor.lastname;
                            });
                            final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
                            readFoodPlan.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("AAAAAAAAAAAAAAAAA");
                              print(foodList.toString());
                              if(datasnapshot.value == null){
                                final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                                foodplanRef.set({"purpose": purpose.toString(), "food": foodList, "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctorName});
                                print("Added Food Plan Successfully! " + uid);
                              }
                              else{
                                getFoodPlan();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = foodplan_list.length--;
                                  final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                                  foodplanRef.set({"purpose": purpose.toString(), "food": foodList, "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctorName});
                                  print("Added Food Plan Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), ()async{
                              print("MEDICATION LENGTH: " + foodplan_list.length.toString());
                              foodplan_list.add(new FoodPlan(purpose: purpose, food: foodList, important_notes: important_notes, prescribedBy: uid, dateCreated: "${now.month}/${now.day}/${now.year}", doctor_name: doctorName));
                              for(var i=0;i<foodplan_list.length/2;i++){
                                var temp = foodplan_list[i];
                                foodplan_list[i] = foodplan_list[foodplan_list.length-1-i];
                                foodplan_list[foodplan_list.length-1-i] = temp;
                              }
                              FoodPlan addedThis = new FoodPlan(doctor: doctor.lastname,purpose: purpose, food: foodList, important_notes: important_notes, prescribedBy: uid, dateCreated: "${now.month}/${now.day}/${now.year}", doctor_name: doctorName);
                              await getNotifs(widget.userUID).then((value) {
                                addtoNotif("Dr. "+doctor.lastname+ " has added something to your Food management plan. Click here to view your new Food management plan. " ,
                                    "Doctor Added to your Food Plan!",
                                    "1",
                                    "Food Plan",
                                    widget.userUID);
                              });

                              print("POP HERE ==========");
                              if(checkboxValue == true){
                                notifyLead(userUID, reason_notification, doctor.lastname, "Food");
                              }
                              Navigator.pop(context, addedThis);
                            });
                          } catch(e) {
                            print("you got an error! $e");
                          }
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  void notifyLead(String userUID, String reasonNotification, String doctorLastName, String planType){
    final connections = databaseReference.child('users/' + userUID + '/personal_info/lead_doctor/' );
    connections.once().then((DataSnapshot snapConnections) async{
      String temp = jsonDecode(jsonEncode(snapConnections.value));
      String leadDoc = temp.toString();
      //ADD NOTIF LOGIC =
      await getNotifs(leadDoc).then((value) {
        addtoNotif("Dr. "+doctorLastName+ " has added something to your patient's $planType management plan. He notes: "+reasonNotification ,
            "Doctor"+ doctorLastName + "Added to your patient's $planType Plan!",
            "1",
            "$planType Plan",
            leadDoc);
      });

    });
    //notifyLead(userUID, reason_notification, doctor.lastname, "Exer");
  }
  List<Widget> _getFood(){
    List<Widget> foodsTextFields = [];
    for(int i=0; i<foodList.length; i++){
      foodsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                Expanded(child: FoodTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonFood(i == foodList.length-1, i),
              ],
            ),
          )
      );
    }
    return foodsTextFields;
  }

  Widget _addRemoveButtonFood(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          foodList.insert(0, null);
        }
        else foodList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
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
  Future<void> getNotifs(String passedUid) async {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = passedUid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
    });
  }
  void addtoRecommendation(String message, String title, String priority,String redirect, String uid){
    final ref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm(uid);
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        ref.set({"id": 0.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + recommList.length.toString());
        ref.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});

      }
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
  void getFoodPlan() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readFood = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
    readFood.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        foodplan_list.add(FoodPlan.fromJson(jsonString));
      });
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
        doctor = Users.fromJson(temp);
      });
      final readPatient = databaseReference.child('users/' + widget.userUID + '/personal_info/');
      readPatient.once().then((DataSnapshot snapshotPatient) {
        Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
        patientTemp.forEach((key, jsonString) {
          patient = Users.fromJson(patientTemp);
        });
        Future.delayed(const Duration(milliseconds: 200), (){
          if(patient.leaddoctor == uid){
            setState(() {
              notifier = false;
            });
          }else notifier= true;
        });
      });
    });
  }

}

class FoodTextFields extends StatefulWidget {
  final int index;
  FoodTextFields(this.index);
  @override
  _FoodTextFieldsState createState() => _FoodTextFieldsState();
}

class _FoodTextFieldsState extends State<FoodTextFields> {
  TextEditingController _nameControllerFoods;

  @override
  void initState() {
    super.initState();
    _nameControllerFoods = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerFoods.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerFoods.text = _addFoodPrescriptionState.foodList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerFoods,
      onChanged: (v) => _addFoodPrescriptionState.foodList[widget.index] = v,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14),
        hintText: "Food",
      ),
      validator: (f){
        if(f.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }


}
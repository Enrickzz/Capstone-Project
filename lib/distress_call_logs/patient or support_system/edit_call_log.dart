import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_call_log extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  String userUID;
  List<distressSOS> thisSOS;
  int index;
  edit_call_log({this.thislist, this.userUID,this.thisSOS,this.index});
  @override
  _editCallLogtate createState() => _editCallLogtate();
}
final _formKey = GlobalKey<FormState>();
class _editCallLogtate extends State<edit_call_log> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  bool isDateSelected= false;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  DateTime now = DateTime.now();
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  String datecreated = "";
  String reason = "";
  String description = "";
  String notes = "";
  DateTime callDate;
  String call_date = (new DateTime.now()).toString();
  String call_time;
  TimeOfDay time;
  var dateValue = TextEditingController();

  int count = 1;
  List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  String valueChooseInterval;
  List<String> listItemSymptoms = <String>[
    '1', '2', '3','4'
  ];
  double _currentSliderValue = 1;
  List <bool> isSelected = [true, false, false, false, false];
  int quantity = 1;
  bool checkboxValue = false;


  String thisURL;

  List<distressSOS> SOS_list = [];

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users doctor = new Users();
  Users patient = new Users();
  bool notifier = true;

  @override
  void initState(){
    initNotif();
    SOS_list = widget.thisSOS;
    int index = SOS_list.length - widget.index;
    print("INDEX" + index.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String userUID = widget.userUID;

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
                    'Edit Distress Call',
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
                      hintText: "Reason",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Reason of Call' : null,
                    onChanged: (val){
                      setState(() => reason = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
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
                      hintText: "Description of Conversation",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Description of Conversation' : null,
                    onChanged: (val){
                      setState(() => description = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
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
                      hintText: "Notes",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Notes' : null,
                    onChanged: (val){
                      setState(() => notes = val);
                    },
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
                        onPressed:()  {
                          final User user = auth.currentUser;
                          final uid = user.uid;
                          final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + widget.index.toString());
                          List<distressSOS> updated = [];
                          updated = widget.thisSOS;
                          updated[widget.index].note = notes;
                          updated[widget.index].call_desc = description;
                          updated[widget.index].reason = reason;

                          ref.update({
                            "reason": reason,
                            "note": notes,
                            "call_desc": description,
                          });
                          Future.delayed(const Duration(milliseconds: 1000), (){
                            Navigator.pop(context, updated);
                          });
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
    connections.once().then((DataSnapshot snapConnections) async {
      String temp = jsonDecode(jsonEncode(snapConnections.value));
      String leadDoc = temp.toString();
      //ADD NOTIF LOGIC =
      await getNotifs(leadDoc).then((value) {
        addtoNotif("Dr. "+doctorLastName+ " has added something to your patient's $planType management plan. He notes: "+reasonNotification ,
            "Dr. "+ doctorLastName + " added to your patient's $planType Plan!",
            "1",
            "$planType Plan",
            leadDoc);
      });

    });
    //notifyLead(userUID, reason_notification, doctor.lastname, "Exer");
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
  void getMedicalPrescription() {
    var userUID = widget.userUID;
    final readprescription = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prescription_list.add(Medication_Prescription.fromJson(jsonString));
      });
    });
  }
  Future <String> downloadUrl(String imagename) async{
    final ref = FirebaseStorage.instance.ref('test/' +widget.userUID +'/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < prescription_list.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+prescription_list[i].imgRef.toString());
      if(prescription_list[i].imgRef.toString() != "null" ){
        downloadurl = await ref.getDownloadURL();
        prescription_list[i].imgRef = downloadurl;
      }

      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
    });
    return downloadurl;
  }
}
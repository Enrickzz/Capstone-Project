import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_lab_request extends StatefulWidget {
  final List<Lab_Plan> thislist;
  String userUID;
  add_lab_request({this.thislist, this.userUID});
  @override
  _addLabRequestState createState() => _addLabRequestState();
}
final _formKey = GlobalKey<FormState>();
class _addLabRequestState extends State<add_lab_request> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  List<Lab_Plan> labplan_list = new List<Lab_Plan>();

  String purpose = " ";
  int frequency = 1;
  String type;
  String important_notes = "";
  String prescribedBy = "";
  String reason_notification = "";
  DateTimeRange dateRange;
  DateTime now =  DateTime.now();
  List<String> listLabResult = <String>[
    '2D Echocardiogram', 'ALT&AST', 'Angiogram',
    'Bun&Creatinine', 'Chest X-ray', 'Complete Blood Count',
    'Electrocardiogram','Filtration Rate', 'Glomerular',
    'Lipid Profile', 'Lung Biopsy' 'MRI CT Scan', 'Prothrombin Time','Pleural Fluid Analysis', 'Serum Electrolytes',
    'Ultrasound', 'Urine Microalbumin', 'A1C Test',
    'Others'
  ];

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users doctor = new Users();

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");
  User user;
  var uid, fileName;

  bool checkboxValue = false;

  @override
  void initState(){
    initNotif();
    super.initState();
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
                    'Lab Result Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),


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
                      hintText: "Laboratory Test:",
                    ),
                    isExpanded: true,
                    value: type,
                    onChanged: (newValue){
                      setState(() {
                        type = newValue;
                      });

                    },
                    items: listLabResult.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),
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
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => important_notes = val);
                    },
                  ),

                  Visibility(visible: pic, child: SizedBox(height: 8.0)),
                  Visibility(
                      visible: pic,
                      child: Container(
                        child: Image.file(file),
                        height:250,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.black
                        ),

                      )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.white,
                        height: 60.0,
                        color: Colors.cyan,
                        onPressed: () async{
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            // type: FileType.custom,
                            // allowedExtensions: ['jpg', 'png'],
                          );
                          if(result == null) return;
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final path = result.files.single.path;
                          user = auth.currentUser;
                          uid = user.uid;
                          fileName = result.files.single.name;
                          file = File(path);
                          PlatformFile thisfile = result.files.first;
                          cacheFile = thisfile.path;
                          Future.delayed(const Duration(milliseconds: 1000), (){
                            setState(() {
                              print("CACHE FILE\n" + thisfile.path +"\n"+file.path);
                              pic = true;
                            });
                          });

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.camera_alt_rounded, color: Colors.white,),
                            ),
                            Text('UPLOAD', )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
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
                              Text("Notify lead doctor"),
                            ],
                          ),

                        ],
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
                            String doctor_name = "";
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
                            Users doctor = new Users();
                            readDoctor.once().then((DataSnapshot snapshot) {
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              doctor_name = doctor.firstname + " " + doctor.lastname;
                            });
                            final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/');
                            readFoodPlan.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              if(datasnapshot.value == null){
                                final labplanRef = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/' + count.toString());
                                labplanRef.set({"Notify_Reason": reason_notification.toString(), "type": type.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctor_name, "imgRef": fileName.toString()});
                                print("Added Lab Plan Successfully! " + uid);
                              }
                              else{
                                getLabPlan();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  downloadUrls();
                                  Future.delayed(const Duration(milliseconds: 1000), (){
                                    count = labplan_list.length--;
                                    final vitalsRef = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/' + count.toString());
                                    vitalsRef.set({"Notify_Reason": reason_notification.toString(), "type": type.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctor_name, "imgRef": fileName.toString()});
                                    print("Added Lab Plan Successfully! " + uid);
                                  });
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), ()async {
                              print("MEDICATION LENGTH: " + labplan_list.length.toString());
                              labplan_list.add(new Lab_Plan(reason_notification: reason_notification,type: type, important_notes: important_notes, prescribedBy: uid, dateCreated: now, doctor_name: doctor_name, imgRef: fileName));
                              for(var i=0;i<labplan_list.length/2;i++){
                                var temp = labplan_list[i];
                                labplan_list[i] = labplan_list[labplan_list.length-1-i];
                                labplan_list[labplan_list.length-1-i] = temp;
                              }
                              if(fileName != null){
                                FirebaseStorage.instance.ref('test/' + uid +"/"+fileName).putFile(file).then((p0) {
                                });
                              }
                              Lab_Plan newV = new Lab_Plan(reason_notification: reason_notification,type: type, important_notes: important_notes, prescribedBy: uid, dateCreated: now, doctor_name: doctor_name, imgRef: fileName);
                              await getNotifs(widget.userUID).then((value) {
                                addtoNotif("Dr. "+doctor.lastname+ " has added something to your Labs management plan. Click here to view your new Food management plan. " ,
                                    "Doctor Added to your Lab Plan!",
                                    "1",
                                    "Lab Plan",
                                    widget.userUID);
                              });

                              if(checkboxValue == true){
                                notifyLead(userUID, reason_notification, doctor.lastname,"Lab Results");
                              }
                              Navigator.pop(context,newV);
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
  void notifyLead(String userUID, String reason_notification, String doctor_lastName, String planType) {
    final connections = databaseReference.child('users/' + userUID + '/personal_info/lead_doctor/' );
    connections.once().then((DataSnapshot snapConnections) async{
      String temp = jsonDecode(jsonEncode(snapConnections.value));
      String lead_doc = temp.toString();
      //ADD NOTIF LOGIC =
      await getNotifs(lead_doc).then((value) {
        addtoNotif("Dr. "+doctor_lastName+ " has added something to your patient's $planType management plan. He notes: "+reason_notification ,
            "Doctor Added to your $planType Plan!",
            "1",
            "Exercise Plan",
            lead_doc);
      });
    });
    //notifyLead(userUID, reason_notification, doctor.lastname, "Exer");
  }
  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    notifsList.clear();
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});
      }else{
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});

      }
    });
  }
  Future<void> getNotifs(String passed_uid) async {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = passed_uid;
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
    });
  }
  void getLabPlan() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readLabPlan = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/');
    readLabPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labplan_list.add(Lab_Plan.fromJson(jsonString));
      });
    });
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < labplan_list.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+labplan_list[i].imgRef.toString());
      if(labplan_list[i].imgRef.toString() != "null" ){
        downloadurl = await ref.getDownloadURL();
        labplan_list[i].imgRef = downloadurl;
      }

      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
    });
    return downloadurl;
  }
}
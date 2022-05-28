import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/management_plan/lab_plan/edit_lab_plan.dart';
import 'package:my_app/services/auth.dart';

import 'package:my_app/models/users.dart';






class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificLabRequestViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificLabRequestViewAsDoctor extends StatefulWidget {
  SpecificLabRequestViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thislist}) : super(key: key);
  final String title;
  String userUID;
  int index;
  List<Lab_Plan> thislist;
  @override
  _SpecificLabRequestViewAsDoctorState createState() => _SpecificLabRequestViewAsDoctorState();
}

class _SpecificLabRequestViewAsDoctorState extends State<SpecificLabRequestViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Lab_Plan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  String type = "";
  String frequency = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  String imgRef = "";
  bool prescribedDoctor = false;

  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;

  //prescription image change this later paki change nalang
  Lab_Plan thisLabPlan;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    final User user = auth.currentUser;
    final uid = user.uid;
    templist.clear();
    templist = widget.thislist;
    downloadUrls();
    thisLabPlan = templist[widget.index];
    type = templist[widget.index].type;
    important_notes = templist[widget.index].important_notes;
    prescribedBy = templist[widget.index].doctor_name;
    dateCreated = "${templist[widget.index].dateCreated.month}/${templist[widget.index].dateCreated.day}/${templist[widget.index].dateCreated.year}";
    if(templist[widget.index].prescribedBy == uid){
      prescribedDoctor = true;
    }
    // getFoodplan();

    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
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
          title: Text('Lab Result Request'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      int initLeng=templist.length;
                      _showMyDialogDelete().then((value) {
                        if(initLeng != templist.length){
                          Navigator.pop(context,value);
                        }
                      });
                    },
                    child: Icon(
                      Icons.delete,
                    ),
                  )
              ),
            ),
          ],
        ),
        body:  WillPopScope(
          onWillPop: () async{
            Navigator.pop(context,templist);
            return true;
          },
          child: Scrollbar(
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
                                  child: Text( "Lab Result Request",
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
                                            child: edit_lab_request(index: widget.index, thislist: widget.thislist, userUID: widget.userUID),
                                          ),
                                          ),
                                        ).then((value) =>
                                            Future.delayed(const Duration(milliseconds: 1500), (){
                                              setState((){
                                                Vitals newV = value;
                                                purpose = newV.purpose;
                                                type = newV.type;
                                                frequency = newV.frequency.toString();
                                                important_notes = newV.important_notes;
                                                prescribedBy = newV.prescribedBy;
                                                dateCreated = "${newV.dateCreated.month}/${newV.dateCreated.day}/${newV.dateCreated.year}";

                                                templist[widget.index].type = type;
                                                templist[widget.index].important_notes = important_notes;
                                                templist[widget.index].prescribedBy =prescribedBy;
                                                templist[widget.index].dateCreated =  newV.dateCreated;
                                                setState(() {

                                                });
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
                                              Text("Requested Lab Result",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
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

                                            ]
                                        ),
                                      ),
                                    )
                                )
                              ]
                          )
                      ),

                      Visibility(
                        visible: hasImage,
                        child: InteractiveViewer(
                          clipBehavior: Clip.none,
                          minScale: minScale,
                          maxScale: maxScale,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: showimg(thisLabPlan.imgRef),
                            ),
                          ),
                        ),
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
                                              Text("Requested by",
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
                                                  Text("Date Requested",
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
          ),
        )
    );


  }
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return Image.asset("assets/images/no-image.jpg");
    }else{
      return Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
      (loadingProgress == null) ? child : CircularProgressIndicator());
    }
  }

  void getLabPlan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readVitals = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/');
    int index = widget.index;
    List<Lab_Plan> temp1 = [];
    readVitals.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        temp1.add(Lab_Plan.fromJson(jsonString));
      });
      for(var i=0;i<temp1.length/2;i++){
        var temp = temp1[i];
        temp1[i] = temp1[temp1.length-1-i];
        temp1[temp1.length-1-i] = temp;
      }
      final readDoctorName = databaseReference.child('users/' + temp1[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      if(temp1[index].prescribedBy == uid){
        prescribedDoctor = true;
      }
      type = temp1[index].type;
      important_notes = temp1[index].important_notes ;
      dateCreated = "${temp1[index].dateCreated.month}/${temp1[index].dateCreated.day}/${temp1[index].dateCreated.year}";
      imgRef = temp1[index].imgRef;
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
                final User user = auth.currentUser;
                final uid = user.uid;
                int initialLength = templist.length;
                templist.removeAt(widget.index);
                /// delete fields
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/lab_plan/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < templist.length; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/lab_plan/' + (i+1).toString());
                  bpRef.set({
                    "type": templist[i].type.toString(),
                    "important_notes": templist[i].important_notes.toString(),
                    "prescribedBy": templist[i].prescribedBy.toString(),
                    "dateCreated": "${templist[i].dateCreated.month.toString().padLeft(2,"0")}/${templist[i].dateCreated.day.toString().padLeft(2,"0")}/${templist[i].dateCreated.year}",
                    "imgRef": templist[i].imgRef.toString(),
                  });
                }
                Navigator.pop(context, templist);
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
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < templist.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+templist[i].imgRef.toString());
      if(templist[i].imgRef.toString() != "null"){
        downloadurl = await ref.getDownloadURL();
        templist[i].imgRef = downloadurl;
      }
      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
      isLoading = false;
    });
    return downloadurl;
  }
}


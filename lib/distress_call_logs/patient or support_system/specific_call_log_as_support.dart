import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/distress_call_logs/patient%20or%20support_system/edit_call_log.dart';
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
      home: SpecificCallLogAsSupport(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificCallLogAsSupport extends StatefulWidget {
  SpecificCallLogAsSupport({Key key, this.title, this.index, this.thislist}) : super(key: key);
  final String title;
  final List<Medication_Prescription> thislist;
  int index;
  @override
  _SpecificCallLogAsSupportState createState() => _SpecificCallLogAsSupportState();
}

class _SpecificCallLogAsSupportState extends State<SpecificCallLogAsSupport> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication_Prescription> prestemp = [];
  Medication_Prescription prescription = new Medication_Prescription();
  Users doctor = new Users();
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;

  //prescription image change this later
  Medication_Prescription thisPrescription;
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
    Future.delayed(const Duration(milliseconds: 1000), (){
      prestemp = widget.thislist;
      downloadUrls();
      thisPrescription = prestemp[widget.index];
      getPrescibedBy();
      setState(() {
        isLoading = false;
      });
    });
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
          title: Text(''),
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

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text( "Distress Call #1",
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
                                      child: edit_call_log(),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){

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
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Date of Call",
                                  style: TextStyle(
                                    fontSize:14,
                                    color:Color(0xFF363f93),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("06/28/2022",
                                  style: TextStyle(
                                      fontSize:16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text("Time of Call",
                                  style: TextStyle(
                                    fontSize:14,
                                    color:Color(0xFF363f93),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("12:00",
                                  style: TextStyle(
                                      fontSize:16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text("Reason",
                                  style: TextStyle(
                                    fontSize:14,
                                    color:Color(0xFF363f93),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("",
                                  style: TextStyle(
                                      fontSize:16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text("Description of Conversation",
                                  style: TextStyle(
                                    fontSize:14,
                                    color:Color(0xFF363f93),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("",
                                  style: TextStyle(
                                      fontSize:16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text("Notes",
                                  style: TextStyle(
                                    fontSize:14,
                                    color:Color(0xFF363f93),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("",
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
                    SizedBox(height: 10.0),


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
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return Image.asset("assets/images/no-image.jpg");
    }else{
      return Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
      (loadingProgress == null) ? child : CircularProgressIndicator());
    }
  }
  // void getPrescription() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
  //   int index = widget.index;
  //   readprescription.once().then((DataSnapshot snapshot){
  //     List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
  //     temp.forEach((jsonString) {
  //       prestemp.add(Medication_Prescription.fromJson(jsonString));
  //     });
  //     brand_name = prestemp[index].branded_name;
  //     generic_name = prestemp[index].generic_name;
  //     dosage = prestemp[index].dosage.toString();
  //     unit = prestemp[index].prescription_unit.toString();
  //     frequency = prestemp[index].intake_time;
  //     special_instruction = prestemp[index].special_instruction;
  //     startDate = "${prestemp[index].startdate.month}/${prestemp[index].startdate.day}/${prestemp[index].startdate.year}";
  //     endDate = "${prestemp[index].enddate.month}/${prestemp[index].enddate.day}/${prestemp[index].enddate.year}";
  //     dateCreated = "${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}";
  //     prescribedBy = prestemp[index].doctor_name;
  //   });
  // }
  void getPrescibedBy(){
    int index = widget.index;
    final readDoctorName = databaseReference.child('users/' + prestemp[index].prescribedBy + '/personal_info/');
    readDoctorName.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
      doctor = Users.fromJson(temp2);
      thisPrescription.prescribedBy = doctor.firstname + " " + doctor.lastname;
    });
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < prestemp.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+prestemp[i].imgRef.toString());
      if(prestemp[i].imgRef.toString() != "null"){
        downloadurl = await ref.getDownloadURL();
        prestemp[i].imgRef = downloadurl;
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
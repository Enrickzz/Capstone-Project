import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/lab_plan/add_lab_plan.dart';
import 'package:my_app/management_plan/lab_plan/specific_lab_plan_doctor_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';


//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class lab_prescription_doctor_view extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  String userUID;
  final List<Connection> connection_list;
  lab_prescription_doctor_view({Key key, this.preslist, this.pointer, this.userUID, this.connection_list}): super(key: key);
  @override
  _lab_management_plan_doctor_view_prescriptionState createState() => _lab_management_plan_doctor_view_prescriptionState();
}

class _lab_management_plan_doctor_view_prescriptionState extends State<lab_prescription_doctor_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Lab_Plan> labplantemp = [];
  List<Connection> connection_list = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  String purpose = "";
  String dateCreated = "";
  Users doctor = new Users();
  List<String> doctor_names = [""];


  @override
  void initState() {
    super.initState();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    connection_list.clear();
    labplantemp.clear();
    connection_list = widget.connection_list;
    getLabPlan(connection_list);
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF2F3F8),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Lab Result Request', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: add_lab_request(thislist: labplantemp, userUID: widget.userUID),
                      ),
                      ),
                    ).then((value) =>
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          setState((){
                            if(value != null){
                              labplantemp.insert(0, value);
                              doctor_names.insert(0, doctor.lastname);
                              Future.delayed(const Duration(milliseconds: 1000),(){
                                setState(() {
                                  if(doctor_names.length == labplantemp.length)
                                    doctor_names.removeAt(1);
                                });
                              });

                            }
                          });
                        }));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: labplantemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.document_scanner_outlined),
                    title: Text(labplantemp[index].type,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle: Text("Requested by: Dr." + labplantemp[index].doctor_name,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${labplantemp[index].dateCreated.month}/${labplantemp[index].dateCreated.day}/${labplantemp[index].dateCreated.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,


                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificLabRequestViewAsDoctor(userUID: widget.userUID, index: index, thislist: labplantemp)),
                      ).then((value) {
                        if(value != null){
                          labplantemp = value;
                          setState(() {

                          });
                        }
                      });
                    }

                ),

              ),
            )
        )
    );
  }
  String getDateFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }
  }
  void getLabPlan(List<Connection> connections) {
    final User user = auth.currentUser;
    final uid = user.uid;
    List<int> deleteList = [];
    String userUID = widget.userUID;
    final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/');
    readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labplantemp.add(Lab_Plan.fromJson(jsonString));
      });
      setState(() {
        for(int i = 0; i < labplantemp.length; i++){
          if(labplantemp[i].prescribedBy != uid){
            for(int j = 0; j < connections.length; j++){
              if(labplantemp[i].prescribedBy == connections[j].doctor1 && uid == connections[j].doctor2){
                if(connections[j].vitals1 != "true"){
                  /// dont add
                  deleteList.add(i);
                }
                else{
                  /// add
                }
              }
              if(labplantemp[i].prescribedBy == connections[j].doctor2 && uid == connections[j].doctor1){
                if(connections[j].vitals2 != "true"){
                  /// dont add
                  deleteList.add(i);
                }
                else{
                  /// add
                }
              }
            }
          }
          final readDoctor = databaseReference.child('users/' + labplantemp[i].prescribedBy + '/personal_info/');
          readDoctor.once().then((DataSnapshot snapshot){
            Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
            if(temp != null){
              doctor = Users.fromJson(temp);
              doctor_names.add(doctor.lastname);
            }
          });
        }
      });
      deleteList.sort((a, b) => b.compareTo(a));
      for(int i = 0; i < deleteList.length; i++){
        labplantemp.removeAt(deleteList[i]);
      }
      for(var i=0;i<labplantemp.length/2;i++){
        var temp = labplantemp[i];
        labplantemp[i] = labplantemp[labplantemp.length-1-i];
        labplantemp[labplantemp.length-1-i] = temp;
      }
      for(var i=0;i<doctor_names.length/2;i++){
        var temp = doctor_names[i];
        doctor_names[i] = doctor_names[doctor_names.length-1-i];
        doctor_names[doctor_names.length-1-i] = temp;
      }
    });
  }

}

String checkthisDoc(String name) {
  if(name == null){
    return "";
  }else{
    return name;
  }
}
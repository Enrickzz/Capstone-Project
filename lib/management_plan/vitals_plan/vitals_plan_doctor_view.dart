import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';

import 'add_vitals_prescription.dart';
import 'package:my_app/management_plan/vitals_plan/specific_vitals_plan_doctor_view.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class vitals_prescription_doctor_view extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  String userUID;
  final List<Connection> connection_list;
  vitals_prescription_doctor_view({Key key, this.preslist, this.pointer, this.userUID, this.connection_list}): super(key: key);
  @override
  _vitals_management_plan_doctor_view_prescriptionState createState() => _vitals_management_plan_doctor_view_prescriptionState();
}

class _vitals_management_plan_doctor_view_prescriptionState extends State<vitals_prescription_doctor_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Vitals> vitalstemp = [];
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
    vitalstemp.clear();
    connection_list = widget.connection_list;
    getVitals(connection_list);
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
          title: const Text('Vitals Recording Planner', style: TextStyle(
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
                        child: add_vitals_prescription(thislist: vitalstemp, userUID: widget.userUID),
                      ),
                      ),
                    ).then((value) =>
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          setState((){
                            if(value != null){
                              vitalstemp.insert(0, value);
                              doctor_names.insert(0, doctor.lastname);
                              Future.delayed(const Duration(milliseconds: 1000),(){
                                setState(() {
                                  if(doctor_names.length == vitalstemp.length)
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
            itemCount: vitalstemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.medical_services_outlined),
                    title: Text("Purpose: " + vitalstemp[index].purpose,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle: Text("Planned by: Dr." + vitalstemp[index].doctor_name,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${vitalstemp[index].dateCreated.month}/${vitalstemp[index].dateCreated.day}/${vitalstemp[index].dateCreated.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,


                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificVitalsPrescriptionViewAsDoctor(userUID: widget.userUID, index: index, thislist: vitalstemp)),
                      ).then((value) {
                        if(value != null){
                          vitalstemp = value;
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
  void getVitals(List<Connection> connections) {
    final User user = auth.currentUser;
    final uid = user.uid;
    List<int> deleteList = [];
    String userUID = widget.userUID;
    final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/');
    readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        vitalstemp.add(Vitals.fromJson(jsonString));
      });
        setState(() {
          for(int i = 0; i < vitalstemp.length; i++){
            if(vitalstemp[i].prescribedBy != uid){
              for(int j = 0; j < connections.length; j++){
                if(vitalstemp[i].prescribedBy == connections[j].doctor1 && uid == connections[j].doctor2){
                  if(connections[j].vitals1 != "true"){
                    /// dont add
                    deleteList.add(i);
                  }
                  else{
                    /// add
                  }
                }
                if(vitalstemp[i].prescribedBy == connections[j].doctor2 && uid == connections[j].doctor1){
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
            final readDoctor = databaseReference.child('users/' + vitalstemp[i].prescribedBy + '/personal_info/');
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
          vitalstemp.removeAt(deleteList[i]);
        }
        for(var i=0;i<vitalstemp.length/2;i++){
          var temp = vitalstemp[i];
          vitalstemp[i] = vitalstemp[vitalstemp.length-1-i];
          vitalstemp[vitalstemp.length-1-i] = temp;
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
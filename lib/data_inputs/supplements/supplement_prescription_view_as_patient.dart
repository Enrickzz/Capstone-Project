import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/supplements/view_specific_supplement_as_patient.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'add_supplement_prescription.dart';


//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class supplement_prescription extends StatefulWidget {
  final List<Supplement_Prescription> preslist;
  final int pointer;
  final String userUID;
  supplement_prescription({Key key, this.preslist, this.pointer, this.userUID}): super(key: key);
  @override
  _supplement_prescriptionState createState() => _supplement_prescriptionState();
}

class _supplement_prescriptionState extends State<supplement_prescription> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Supplement_Prescription> supptemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  List<Connection> connections = [];
  bool canaddedit = false;

  @override
  void initState() {
    super.initState();
    supptemp.clear();
    getpermission();
    getSupplementPrescription();
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
        title: const Text('Supplements & Other Medicines', style: TextStyle(
            color: Colors.black,
          fontSize: 16,
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Visibility(
            visible: canaddedit,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: add_supplement_prescription(thislist: supptemp, userUID: widget.userUID),
                      ),
                      ),
                    ).then((value) =>
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          // supptemp = value;
                          if(value != null){
                            print("LENGTH: " + supptemp.length.toString());
                            supptemp.insert(0, value);
                          }
                          setState((){
                            if(value != null){
                            }
                          });
                        }));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: supptemp.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) =>Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Card(
            child: ListTile(
                leading: Icon(Icons.medication_outlined ),
                title: Text(supptemp[index].supplement_name ,
                    style:TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,

                    )),
                subtitle:        Text(supptemp[index].dosage.toString() + supptemp[index].prescription_unit,
                    style:TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    )),
                trailing: Text("${supptemp[index].dateCreated.month.toString().padLeft(2, "0")}/${supptemp[index].dateCreated.day.toString().padLeft(2, "0")}/${supptemp[index].dateCreated.year}",
                    style:TextStyle(
                      color: Colors.grey,
                    )),
                isThreeLine: true,
                dense: true,
                selected: true,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpecificSupplementViewAsPatient(index: index)),
                  ).then((value) {
                    if(value != null){
                      print("length b4 = " + supptemp.length.toString());
                      supptemp = value;
                      print("length af = " +supptemp.length.toString());
                      setState(() {
                        supptemp = value;
                      });
                    }
                  });
                }

            ),

          ),
        )
    ),
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
  void getSupplementPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsupplement = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        supptemp.add(Supplement_Prescription.fromJson(jsonString));
      });
      for(var i=0;i<supptemp.length/2;i++){
        var temp = supptemp[i];
        supptemp[i] = supptemp[supptemp.length-1-i];
        supptemp[supptemp.length-1-i] = temp;
      }
      print(supptemp[0].supplement_name);
    });
  }
  void getpermission() {
    final User user = auth.currentUser;
    String ssuid = user.uid;
    final uid = widget.userUID;
    final readConnection = databaseReference.child('users/' + uid + '/personal_info/connections');
    readConnection.once().then((DataSnapshot datasnapshot) {
      List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
      temp.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString));
      });
      for(int i = 0; i < connections.length; i++){
        if(connections[i].doctor1 == ssuid){
          if(connections[i].addedit == "true"){
            canaddedit = true;
            print("canaddedit is ");
            print(canaddedit);
          }
          else{
            canaddedit = false;
            print("canaddedit is ");
            print(canaddedit);
          }
        }
      }
    });
  }
}
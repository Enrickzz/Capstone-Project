
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_status extends StatefulWidget {
  // final List<FoodPlan> thislist;
  final String userUID;
  final String status;
  edit_status({this.status, this.userUID});
  @override
  _editStatus createState() => _editStatus();
}
final _formKey = GlobalKey<FormState>();
class _editStatus extends State<edit_status> {


  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();


  final _formKey = GlobalKey<FormState>();

  String firstname = "";
  String lastname = "";
  String weight = "";
  String height = "";

  //birthday
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "";
  bool isDateSelected= false;
  var dateValue = TextEditingController();
  bool isSwitchedHospitalized = false;
  List<Connection> connections = [];
  List<String> roles = [];
  List<int> list_ss = [];
  int count = 0;

  void initState() {
    super.initState();
    if(widget.status != null){
      if(widget.status == "Hospitalized"){
        isSwitchedHospitalized = true;
      }
      else{
        isSwitchedHospitalized = false;
      }
    }
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
                'Edit Status',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8),

              SwitchListTile(
                title: Text('Hospitalized'),
                subtitle: Text('Patient is hospitalized'),
                secondary:                                  Image.asset(
                  'assets/images/hospitalization.png',
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                value: isSwitchedHospitalized,
                onChanged: (value){
                  setState(() {
                    isSwitchedHospitalized = value;
                  });
                },
              ),

              Visibility(
                visible: isSwitchedHospitalized,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Disclaimer: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),

                    ),
                    SizedBox(height: 8.0),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "All your support system will be able to add and edit your data inputs." +"\n\n"+ "You have the ability to revoke their access to add and edit your data inputs."+"\n\n"+"To do so, go to Manage Healthcare Team.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      ),

                    ),

                  ],
                ),
              ),


              SizedBox(
                height: 8,
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
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed:() {
                      try{
                        if(widget.userUID != null){
                          var uid = widget.userUID;
                          if(isSwitchedHospitalized){
                            final bpRef = databaseReference.child('users/' + uid + '/personal_info/');
                            bpRef.update({"status": "Hospitalized"});
                            final readConnection = databaseReference.child('users/' + uid + '/personal_info/connections');
                            readConnection.once().then((DataSnapshot datasnapshot) {
                              List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
                              temp.forEach((jsonString) {
                                connections.add(Connection.fromJson(jsonString));
                              });
                              for(int i = 0; i < connections.length; i++){
                                final readrole = databaseReference.child('users/' + connections[i].doctor1 + '/personal_info/userType');
                                readrole.once().then((DataSnapshot snapshot) {
                                  print(snapshot.value);
                                  if(snapshot.value == "Family member / Caregiver"){
                                    final conRef = databaseReference.child('users/' + uid + '/personal_info/connections/' + (i+1).toString() + '/');
                                    conRef.update({"addedit": "true"});
                                  }
                                });
                              }
                            });
                          }
                          else{
                            final bpRef = databaseReference.child('users/' + uid + '/personal_info/');
                            bpRef.update({"status": "Active"});
                          }
                        }
                        else{
                          final User user = auth.currentUser;
                          var uid = user.uid;
                          if(isSwitchedHospitalized){
                            final bpRef = databaseReference.child('users/' + uid + '/personal_info/');
                            bpRef.update({"status": "Hospitalized"});
                            final readConnection = databaseReference.child('users/' + uid + '/personal_info/connections');
                            readConnection.once().then((DataSnapshot datasnapshot) {
                              List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
                              temp.forEach((jsonString) {
                                connections.add(Connection.fromJson(jsonString));
                              });
                              for(int i = 0; i < connections.length; i++){
                                final readrole = databaseReference.child('users/' + connections[i].doctor1 + '/personal_info/userType');
                                readrole.once().then((DataSnapshot snapshot) {
                                  print(snapshot.value);
                                  if(snapshot.value == "Family member / Caregiver"){
                                    final conRef = databaseReference.child('users/' + uid + '/personal_info/connections/' + (i+1).toString() + '/');
                                    conRef.update({"addedit": "true"});
                                  }
                                });
                              }
                            });
                          }
                          else{
                            final bpRef = databaseReference.child('users/' + uid + '/personal_info/');
                            bpRef.update({"status": "Active"});
                          }
                        }

                        Navigator.pop(context);
                      } catch(e) {
                        print("you got an error! $e");
                      }

                    },

                  )
                ],
              ),


            ]

        ),


      ),



    );
  }
}

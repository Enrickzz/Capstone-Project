import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/patient_list/doctor/doctor_add_patient.dart';
import 'package:my_app/profile/doctor/doctor_edit_management_privacy.dart';
import 'package:my_app/profile/doctor/doctor_view_patient_profile.dart';
import 'package:my_app/profile/patient/data_privacy/patient_adjust_privacy.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_app/main.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/profile/patient/patient_view_support_system.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support System List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: doctor_view_patient_support_system(title: 'Flutter Demo Home Page'),
    );
  }
}

class doctor_view_patient_support_system extends StatefulWidget {
  doctor_view_patient_support_system({Key key, this.userUID, this.title
    // , this.nameslist, this.diseaselist, this.uidList
  }) : super(key: key);
  final String title;
  // final List nameslist;
  // final List diseaselist;
  // final List<String> uidList;
  final String userUID;
  @override
  _SupportSystemListState createState() => _SupportSystemListState();
}
class _SupportSystemListState extends State<doctor_view_patient_support_system>  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users patient = new Users();
  bool isme = false;


  List<String> uidlist = [];
  List<Connection> connections = [];
  List<Users> userlist = [];
  List<Additional_Info> userAddInfo =[];

  List names = [
    //   "Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
    // "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"
  ];

  List position = [
    // "Cardiologist", "Endocrinologist", 'Endocrinologist', "Cardiologist",
    // "Endocrinologist", "Cardiologist", 'Endocrinologist', "Cardiologist", 'Endocrinologist', "Cardiologist"
  ];

  @override
  void initState(){
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    getPatients();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
        for(int i = 0; i < userlist.length; i++){
          if(userlist[i].uid == uid){
            isme = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text(" 's Doctors", style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [

          ],
        ),
        body: ListView.builder(
            itemCount: names.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.green,
                    backgroundImage: NetworkImage
                      ("https://quicksmart-it.com/wp-content/uploads/2020/01/blank-profile-picture-973460_640-1.png"),
                  ),
                  title: Text(names[index],
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,

                      )),
                  subtitle:        Text(position[index],
                      style:TextStyle(
                        color: Colors.grey,
                      )),
                  trailing: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: doctor_edit_management_privacy(userUID: widget.userUID, doctorUID: userlist[index].uid),
                          ),
                          ),
                        ).then((value) =>
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              setState((){
                                print("setstate medication prescription");
                                print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                                if(value != null){
                                  // templist = value[0];
                                }
                              });
                            }));
                      },
                      child: Icon(Icons.admin_panel_settings_rounded )
                  ),
                  isThreeLine: true,
                  dense: true,
                  selected: true,


                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => view_patient_profile(patientUID: uidlist[index])),
                  //   );
                  // }

                ),

              ),
            )

        )


    );


  }

  // void getPatients() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
  //   readPatient.once().then((DataSnapshot snapshot){
  //     var temp1 = jsonDecode(jsonEncode(snapshot.value));
  //     patient = Users.fromJson2(temp1);
  //     for(int i = 0; i < patient.connections.length; i++){
  //       uidlist.add(patient.connections[i]);
  //     }
  //     for(int i = 0; i < uidlist.length; i++){
  //       final readDoctor = databaseReference.child('users/' + uidlist[i] + '/personal_info/');
  //       // final readInfo = databaseReference.child('users/' + uidlist[i] + '/vitals/additional_info/');
  //       readDoctor.once().then((DataSnapshot snapshot){
  //         var temp1 = jsonDecode(jsonEncode(snapshot.value));
  //         print("temp1");
  //         print(temp1);
  //         Users doctor = Users.fromJson(temp1);
  //         // readInfo.once().then((DataSnapshot snapshot){
  //         var temp2 = jsonDecode(jsonEncode(snapshot.value));
  //         print(temp2);
  //         String specialty = "";
  //         // Additional_Info info = Additional_Info.fromJson4(temp2);
  //         specialty = doctor.specialty;
  //
  //         position.add(specialty);
  //         // });
  //
  //         names.add(doctor.firstname + " " + doctor.lastname);
  //         print(names);
  //       });
  //     }
  //   });
  //
  // }
  void getPatients(){
    String userUID = widget.userUID;
    final readConnection = databaseReference.child('users/' + userUID + '/personal_info/connections/');
    readConnection.once().then((DataSnapshot snapshot){
      List<dynamic> temp1 = jsonDecode(jsonEncode(snapshot.value));
      temp1.forEach((jsonString) {
        connections.add(Connection.fromJson2(jsonString));
      });
      for(int i = 0; i < connections.length; i++){
        final readDoctor = databaseReference.child('users/' + connections[i].uid + '/personal_info/');
        readDoctor.once().then((DataSnapshot datasnapshot){
          Map<String, dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
          userlist.add(Users.fromJson(temp2));
          if(userlist[i].usertype != "Doctor"){
            userlist.removeAt(i);
          }
          else{
            names.add(userlist[i].firstname+ " " + userlist[i].lastname);
            position.add(userlist[i].specialty);
          }
          print(names);
        });
      }

    });


  }

}
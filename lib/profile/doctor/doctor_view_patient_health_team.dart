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
  List<Connection> doctor_connection = [];
  List<String> uidlist = [];
  List<Connection> connections = [];
  List<Connection> doctorconnections = [];
  List<Users> userlist = [];
  List<Additional_Info> userAddInfo =[];
  List<int> delete_list = [];
  Connection target_connection;
  int tryCount = 0;
  List names = [
    //   "Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
    // "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"
  ];

  List position = [
    // "Cardiologist", "Endocrinologist", 'Endocrinologist', "Cardiologist",
    // "Endocrinologist", "Cardiologist", 'Endocrinologist', "Cardiologist", 'Endocrinologist', "Cardiologist"
  ];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    bool duplicate = false;
    getPatients();
    Future.delayed(const Duration(milliseconds: 2000), (){
        List<Connection> tempConn=[];
        print("SETSTATE LENGTH");
        print(tryCount.toString());
        doctorconnections.length = tryCount;
        print(doctorconnections.length);

        // delete_list.sort((a, b) => b.compareTo(a));
        // for(int i = 0; i < delete_list.length; i++){
        //   userlist.removeAt(delete_list[i]);
        //   connections.removeAt(delete_list[i]);
        // }
        // for(int i = 0; i < userlist.length; i++){
        //   if(userlist[i].uid == uid){
        //     userlist[i].isMe = true;
        //   }
        //   else{
        //     userlist[i].isMe = false;
        //   }
        // }
        // userlist.clear();
        for(var i = 0 ; i < doctorconnections.length; i++){
          duplicate = false;
          getname(doctorconnections[i].createdBy).then((value) {
            Users addme = value;
            for(var j = 0; j <names.length; j++){
              if(names[j].toString().contains(addme.firstname) && names[j].toString().contains(addme.lastname)){
                duplicate = true;
              }
            }
            print("LOOP $i + " + addme.firstname + " " + addme.lastname );
            print(addme.specialty);
            String addname = addme.firstname + " " + addme.lastname;
            if(!duplicate){
              names.add(addname);
              print(names.length);
              position.add(addme.specialty);
              if(addme.uid == uid){
                addme.isMe=true;
              }else addme.isMe= false;
              userlist.add(addme);
            }
          });
          print(doctorconnections[i].createdBy + " \t" + doctorconnections[i].uid);
        }
        var temp = names.toSet().toList();
        names = temp;
        for(int i = 0; i < userlist.length; i++){
          if(userlist[i].uid == uid){
            userlist[i].isMe = true;
          }
          else{
            userlist[i].isMe = false;
          }
        }
        Future.delayed(const Duration(milliseconds: 2000), (){
          setState(() {
            isLoading=false;
          });
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
          title: const Text("Patient's Doctors", style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [

          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new  ListView.builder(
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
                  title: Text(names[index].toString(),
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,

                      )),
                  subtitle:        Text(position[index],
                      style:TextStyle(
                        color: Colors.grey,
                      )),

                  trailing: Visibility(
                    visible:  !userlist[index].isMe,
                    child: GestureDetector(

                        onTap: () {

                          showModalBottomSheet(context: context,
                            isScrollControlled: true,
                            builder: (context) => SingleChildScrollView(child: Container(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: doctor_edit_management_privacy(userUID: widget.userUID, doctorUID: userlist[index].uid,index: index, connection: doctorconnections[index]),
                            ),
                            ),
                          ).then((value) =>
                              Future.delayed(const Duration(milliseconds: 1500), (){
                                setState((){
                                  if(value != null){
                                    // templist = value[0];
                                  }
                                });
                              }));
                        },

                        child: Icon(Icons.admin_panel_settings_rounded )
                    ),
                  ),


                  isThreeLine: true,
                  dense: true,
                  selected: true,

                ),

              ),
            )

        )


    );


  }

  Future<Users> getname(String idLooped) async{
    final readname = databaseReference.child('users/' + idLooped + '/personal_info/');
    Users ret;
    await readname.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> jsonName = jsonDecode(jsonEncode(snapshot.value));
      Users thisName = Users.fromJson(jsonName);
      print(thisName.firstname + "<<<<<<<<" + thisName.lastname);
      ret = thisName;
    });
    return ret;

  }
  void getPatients(){
    final User user = auth.currentUser;
    final uid = user.uid;
    String userUID = widget.userUID;
    Users usertype = new Users();
    List<int> listdelete = [];
    connections.clear();
    final readConnection = databaseReference.child('users/' + userUID + '/personal_info/connections/');
    readConnection.once().then((DataSnapshot snapshot){
      List<dynamic> temp1 = jsonDecode(jsonEncode(snapshot.value));
      temp1.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString));
      });
      // for(int i = 0; i < connections.length; i++){
      //   final readDoctor = databaseReference.child('users/' + connections[i].uid + '/personal_info/');
      //   readDoctor.once().then((DataSnapshot datasnapshot){
      //     Map<String, dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
      //     userlist.add(Users.fromJson(temp2));
      //     if(userlist[i].usertype != "Doctor"){
      //       delete_list.add(i);
      //       // userlist.removeAt(i);
      //     }
      //     else{
      //       // names.add(userlist[i].firstname+ " " + userlist[i].lastname);
      //       // position.add(userlist[i].specialty);
      //     }
      //   });
      // }
      for(int i = 0; i < connections.length; i++){
        final readUsertype = databaseReference.child('users/' + connections[i].uid + '/personal_info/');
        final readDoctorConnection = databaseReference.child('users/' + uid + '/personal_info/connections/');
        readUsertype.once().then((DataSnapshot snapshot){
          readDoctorConnection.once().then((DataSnapshot datasnapshot){
          Map<String, dynamic> temp4 = jsonDecode(jsonEncode(snapshot.value));
          usertype = Users.fromJson(temp4);
          if(usertype.usertype == "Doctor"){
            tryCount++;
            //connections[i].uid is list of doctor uid
              List<dynamic> temp3 = jsonDecode(jsonEncode(datasnapshot.value));
              if(datasnapshot.value != null){
                temp3.forEach((jsonString) {
                  if(jsonString.toString().contains(userUID)){
                    doctorconnections.add(Connection.fromJson2(jsonString));
                  }

                });
              }
            }
          });
        });
      }
    });
    final readPatient = databaseReference.child('users/' + userUID + '/personal_info/');
    readPatient.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        patient = Users.fromJson(temp2);
    });
  }
}
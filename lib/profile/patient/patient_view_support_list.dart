import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/profile/patient/data_privacy/patient_adjust_privacy.dart';
import 'package:my_app/profile/patient/data_privacy/select_support_system.dart';
import 'package:my_app/profile/patient/select_lead_doctor.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: SupportSystemList(title: 'Flutter Demo Home Page'),
    );
  }
}

class SupportSystemList extends StatefulWidget {
  SupportSystemList({Key key, this.title, this.nameslist, this.diseaselist, this.uidList}) : super(key: key);
  final String title;
  final List nameslist;
  final List diseaselist;
  final List<String> uidList;
  @override
  _SupportSystemListState createState() => _SupportSystemListState();
}
class _SupportSystemListState extends State<SupportSystemList> with SingleTickerProviderStateMixin  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users patient = new Users();
  List<bool> islead = [];
  List<String> uidlist = [];
  List<Users> userlist=[];
  List<Additional_Info> userAddInfo =[];
  List<Connection> connections = [];

  List d_names = [
    //   "Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
    // "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"
  ];
  List lead_names = [];
  List<String> d_uid = [];List<String> ss_uid = [];
  List ss_names = [
    //   "Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
    // "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"
  ];

  List d_position = [
    // "Doctor", "Doctor", 'Support System', "Coronary Heart Disease",
    // "Doctor", "Support System", 'Doctor', "Support System", 'Doctor', "Doctor"
  ];
  List ss_position = [
    // "Doctor", "Doctor", 'Support System', "Coronary Heart Disease",
    // "Doctor", "Support System", 'Doctor', "Support System", 'Doctor', "Doctor"
  ];

  final List<String> tabs = ['Doctors', 'Support Systems'];
  TabController controller;

  @override
  void initState(){
    super.initState();
    getPatients();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {});
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
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Health Team', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: controller,
            indicatorColor: Colors.grey,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs:<Widget>[
              Tab(
                text: 'Doctors',
              ),
              Tab(
                text: 'Support Systems',
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: select_lead_doctor(d_names: lead_names, d_uid: d_uid),
                  ),
                  ),
                ).then((value) async {
                  print("VALLLUEE");
                  print(value);
                  if(value != null){
                    for(int i = 0; i < d_uid.length; i++){
                      if(value == d_uid[i]){
                        islead[i] = true;
                      }
                      else{
                        islead[i] = false;
                      }
                    }
                  }

                  setState(() {});
                });
              },
              child: ImageIcon(
                AssetImage('assets/images/lead.png'),
                size: 20,
              ),
            ),
            SizedBox(width: 15),
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: select_support_system(d_names: d_names, d_uid: d_uid),
                      ),
                      ),
                    ).then((value) async {
                      print("VALLLUEE");
                      print(value);
                      if(value != null){
                        for(int i = 0; i < d_uid.length; i++){
                          if(value == d_uid[i]){
                            islead[i] = true;
                          }
                          else{
                            islead[i] = false;
                          }
                        }
                      }

                      setState(() {});
                    });

                  },
                  child: Icon(
                    Icons.quick_contacts_dialer_rounded,
                    size: 26,
                  ),
                )
            ),

            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HealthTeam()),
                    );


                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
          ],
        ),
        body: TabBarView(
          controller: controller,
          children: [
            Container(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: d_names.length,
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
                            title: Text(d_names[index],
                                style:TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,

                                )),
                            subtitle:        Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d_position[index],
                                    style:TextStyle(
                                      color: Colors.grey,
                                    )),
                                SizedBox(height: 3,),
                                Visibility(
                                  visible: islead[index],
                                  child: Text("Lead Doctor",
                                      style:TextStyle(
                                        color: Colors.grey,
                                      )),
                                ),
                              ],
                            ),

                            trailing: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: patient_edit_privacy(connection: connections[index]),
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

                ),
              ),
            ),
            Container(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: ss_names.length,
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
                          title: Text(ss_names[index],
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,

                              )),
                          subtitle:        Text(ss_position[index],
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
                                    child: patient_edit_privacy(connection: connections[index+d_uid.length]),
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

                ),
              ),
            ),
          ],
        )


    );


  }

  void getPatients() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
    final readPatientConnection = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readPatient.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      patient = Users.fromJson2(temp1);
      readPatientConnection.once().then((DataSnapshot datasnapshot){
        List<dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
        temp2.forEach((jsonString) {
          connections.add(Connection.fromJson(jsonString));
        });
        for(int i = 0; i < connections.length; i++){
          uidlist.add(connections[i].doctor1);
        }
        print(uidlist);
        for(int i = 0; i < uidlist.length; i++){
          final readDoctor = databaseReference.child('users/' + uidlist[i] + '/personal_info/');
          // final readInfo = databaseReference.child('users/' + uidlist[i] + '/vitals/additional_info/');
          readDoctor.once().then((DataSnapshot snapshot){
            var temp3 = jsonDecode(jsonEncode(snapshot.value));
            Users doctor = Users.fromJson(temp3);
            if(doctor.usertype != "Family member / Caregiver"){
              d_names.add(doctor.firstname + " " + doctor.lastname);
              if(doctor.specialty == "Cardiologist"){
                lead_names.add(doctor.firstname + " " + doctor.lastname);
              }
              d_uid.add(doctor.uid);
              d_position.add(doctor.specialty);
              print("ISLEEEEEEEEEEEEEEAD");
              print("HUUUU" + patient.leaddoctor);
              print(doctor.uid);
              if(patient.leaddoctor == doctor.uid){
                islead.add(true);
              }
              else{
                islead.add(false);
              }

              print(islead);
            }
            else{
              ss_names.add(doctor.firstname + " " + doctor.lastname);
              ss_position.add("Family member / Caregiver");
              ss_uid.add(doctor.uid);
            }

          });
        }
      });
    });

  }

}
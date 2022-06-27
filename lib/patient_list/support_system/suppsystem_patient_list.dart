import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/notifications/notifications_doctor.dart';
import 'package:my_app/patient_list/support_system/suppsystem_add_patient.dart';
import 'package:my_app/profile/support_system/add_image_supportsystem.dart';
import 'package:my_app/profile/support_system/suppsystem_view_patient_profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';
import '../../models/users.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientListSupportSystemView(title: 'Flutter Demo Home Page'),
    );
  }
}

class PatientListSupportSystemView extends StatefulWidget {
  PatientListSupportSystemView({Key key, this.title, this.patients, this.diseaselist}) : super(key: key);
  final List patients;
  final List diseaselist;
  final String title;

  @override
  _PatientListState createState() => _PatientListState();
}
class _PatientListState extends State<PatientListSupportSystemView>  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users supp_system = new Users(email: "", firstname: "", lastname: "");
  List<Connection> supp_connections = [];

  List<String> uidlist = [];
  List<Users> patients=[];
  List<Additional_Info> userAddInfo =[];
  // List names = [];
  // List pp_imgs = [];
  List diseases=[];
  // List<String> status = [];

  //for drawer
  var imagesVisible = true;
  var cardContent = [];
  bool isLoading = true;

  // profile pic
  String pp_img = "";
  String ss_ppimg = "";

  @override
  void initState(){
    var ran = Random();

    getSupportSystem();

    for (var i = 0; i < 5; i++) {
      var heading = '\$${(ran.nextInt(20) + 15).toString()}00 per month';
      var subheading =
          '${(ran.nextInt(3) + 1).toString()} bed, ${(ran.nextInt(2) + 1).toString()} bath, ${(ran.nextInt(10) + 7).toString()}00 sqft';
      var cardImage = NetworkImage(
          'https://source.unsplash.com/random/800x600?house&' +
              ran.nextInt(100).toString());
      var supportingText =
          'Beautiful home, recently refurbished with modern appliances...';
      var cardData = {
        'heading': heading,
        'subheading': subheading,
        'cardImage': cardImage,
        'supportingText': supportingText,
      };
      cardContent.add(cardData);
    }

    if(widget.patients != null){
      if(widget.patients.isNotEmpty){
        patients = widget.patients;
        diseases = widget.diseaselist;
        List temp = [];
        temp = patients;
        patients = temp.toSet().toList();
      }
    }else{
      patients.clear();
      getPatients();
      isLoading = true;
    }
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        isLoading = false;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Patient List', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
                onTap: () async {
                  showPatientStatusLegend();

                },
                child: Image.asset(
                  "assets/images/tite.png",
                  width: 14,
                  height: 14,
                )
            ),
            SizedBox(width: 24),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new ListView.builder(
            itemCount: patients.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Stack(
                        children:[ Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 2, color: Colors.white),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(5, 5),),
                              ],
                            ),
                            height: 50,
                            width: 50,
                            child: ClipOval(
                              // child:Image.asset("assets/images/blank_person.png",
                                child: checkimage(patients[index].pp_img)),
                          ),
                        ),
                          if(patients[index].status == "Active")...[
                            Positioned(
                              left:35,
                              top:34,
                              child: Container(
                                height: 14,
                                width: 14,
                                child: ClipOval(
                                    child:Image.asset("assets/images/active.png",
                                    )),
                              ),
                            ),
                          ] else if(patients[index].status == "Hospitalized")... [
                            Positioned(
                              left:35,
                              top:34,
                              child: Container(
                                height: 14,
                                width: 14,
                                child: ClipOval(
                                    child:Image.asset("assets/images/hospitalized.png",
                                    )),
                              ),
                            ),
                          ] else ... [
                            Positioned(
                              left:35,
                              top:34,
                              child: Container(
                                height: 14,
                                width: 14,
                                child: ClipOval(
                                    child:Image.asset("assets/images/inactive.png",
                                    )),
                              ),
                            ),
                          ]

                        ]
                    ),
                    title: Text(patients[index].firstname +" "+ patients[index].lastname,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text(diseases[index],
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    trailing: Icon(Icons.sick_rounded ),
                    isThreeLine: true,
                    dense: true,
                    selected: true,


                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => suppsystem_view_patient_profile(userUID: patients[index].uid)),
                      );


                    }

                ),

              ),
            )

        ),
        drawer: _buildDrawer(context)


    );


  }


  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addImageSupport(img: ss_ppimg)),
                );
              },
              child: ClipOval(child: checkimage(ss_ppimg))
            ),
            accountEmail: Text(supp_system.email,style: TextStyle(fontSize: 12.0)),
            accountName: Text(
              supp_system.firstname + " " + supp_system.lastname,
              style: TextStyle(fontSize: 16.0),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),

          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => notifications_doctor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text(
              'Add Patients',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportAddPatient(patients: patients,diseaseList: diseases)),
              );
            },
          ),

          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Sign Out',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () async{
              await _auth.signOut();
              print('signed out');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> showPatientStatusLegend() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Status'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[


                SizedBox(height: 12.0,),

                SizedBox(height: 5,),

                Row(
                  children: [
                    Image.asset(
                      'assets/images/active.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Active',
                      style: TextStyle(color: Color(0xFF388E3C),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                ),
                SizedBox(height: 5,),

                Text('This patient is a regular user of Heartistant who has recorded health and non-health data in the past 6 months',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/hospitalized.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Hospitalized',
                      style: TextStyle(color: Color(0xFFF44336),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],


                ),


                SizedBox(height: 5,),

                Text('This patient is currently hospitalized and would not receive any notifications or recommendations from Heartistant',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/inactive.png',
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 20,),
                    Text('Inactive',
                      style: TextStyle(color: Color(0xFF90A4AE),fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                ),

                SizedBox(height: 5,),

                Text('This patient is inactive and has not logged in to Heartistant in the past 6 months',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),),
                SizedBox(height: 5,),



              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void getPatients() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    final readDoctorConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    await readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      supp_system = Users.fromJson(temp1);
      readDoctorConnections.once().then((DataSnapshot datasnapshot){
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        temp.forEach((jsonString) {
          supp_connections.add(Connection.fromJson(jsonString));
        });
        for(int i = 0; i < supp_connections.length; i++){
          uidlist.add(supp_connections[i].doctor1);
        }
        for(int i = 0; i < uidlist.length; i++){
          print(uidlist[i]);
          final readPatient = databaseReference.child('users/' + uidlist[i] + '/personal_info/');
          final readInfo = databaseReference.child('users/' + uidlist[i] + '/vitals/additional_info/');
          readPatient.once().then((DataSnapshot snapshot){
            var temp1 = jsonDecode(jsonEncode(snapshot.value));
            Users patient = Users.fromJson(temp1);
            patients.add(patient);
            readInfo.once().then((DataSnapshot snapshot){
              var temp2 = jsonDecode(jsonEncode(snapshot.value));
              String diseaseName = "";
              Additional_Info info = Additional_Info.fromJson4(temp2);
              for(int j = 0; j < info.disease.length; j++){
                if(j == info.disease.length - 1){
                  print("if statement " + info.disease[j]);
                  diseaseName += info.disease[j];
                }
                else{
                  print("else statement " + info.disease[j]);
                  diseaseName += info.disease[j] + ", ";
                }
              }
              diseases.add(diseaseName);
            });
          });
        }
      });

    }).then((value){
      setState(() {
        isLoading = false;
        print("FIXED");
      });
    });

  }

  void getSupportSystem() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    await readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      supp_system = Users.fromJson(temp1);
      ss_ppimg = supp_system.pp_img;
    });
  }

  Widget checkimage(String img) {
    if(img == null || img == "assets/images/blank_person.png"){
      return Image.asset("assets/images/blank_person.png", width: 70, height: 70,fit: BoxFit.cover);
    }else{
      return Image.network(img,
          width: 50,
          height: 50,
          fit: BoxFit.cover);
    }
  }
}
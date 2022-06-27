import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/notifications/notifications_doctor.dart';
import 'package:my_app/patient_list/doctor/doctor_add_patient.dart';
import 'package:my_app/profile/doctor/doctor_view_patient_profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/profile/doctor/add_image_doctor.dart';

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
      home: PatientList(title: 'Flutter Demo Home Page'),
    );
  }
}

class PatientList extends StatefulWidget {
  PatientList({Key key, this.title, this.patients, this.diseaselist}) : super(key: key);
  final List patients;
  final List diseaselist;
  final String title;

  @override
  _PatientListState createState() => _PatientListState();
}
class _PatientListState extends State<PatientList>  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users doctor = new Users(email: "", firstname: "", lastname: "");
  List<Connection> doctor_connections = [];

  List<Users> patients = [];
  List<Uid> patient_list = [];
  List<Additional_Info> userAddInfo = [];
  List diseases=[];
  List<String> unique_uidlist = [];
  List<String> status = [];


  //for drawer
  var imagesVisible = true;
  var cardContent = [];
  bool isLoading = true;

  // profile pic
  String pp_img = "";
  String doctor_ppimg = "";

  @override
  void initState(){
    var ran = Random();
    getDoctor();
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
      setState(() {

      });
    }
    super.initState();
    if(widget.patients != null){
      if(widget.patients.isNotEmpty){
        print("WIDGET NAMES NOT EMPTY");
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
        arrangeActive(patients);
        isLoading = false;
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
                  trailing: Icon(Icons.sick ),
                  isThreeLine: true,
                  dense: true,
                  selected: true,


                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => view_patient_profile(userUID: patients[index].uid)),
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
                  MaterialPageRoute(builder: (context) => addImageDoctor(img: pp_img)),
                );
              },
              child: ClipOval(child: checkimage(doctor_ppimg))
            ),
            accountEmail: Text(doctor.email,style: TextStyle(fontSize: 12.0)),
            accountName: Text(
              doctor.firstname + " " + doctor.lastname,
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
                MaterialPageRoute(builder: (context) => DoctorAddPatient(patients: patients,diseaseList: diseases)),);
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
    final readPatientList = databaseReference.child('users/' + uid + '/personal_info/patient_list/');
    await readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      print(temp1);
      doctor = Users.fromJson(temp1);
      readPatientList.once().then((DataSnapshot datasnapshot){
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        print(temp);
        print("LIST OF USER UID HERE");
        temp.forEach((jsonString) {
          patient_list.add(Uid.fromJson(jsonString));
        });
        for(int i = 0; i < patient_list.length; i++){
          final readPatient = databaseReference.child('users/' + patient_list[i].uid + '/personal_info/');
          final readInfo = databaseReference.child('users/' + patient_list[i].uid + '/vitals/additional_info/');
          readPatient.once().then((DataSnapshot pshot){
            var temp5 = jsonDecode(jsonEncode(pshot.value));
            print(temp5);
            Users patient = Users.fromJson(temp5);
            patients.add(patient);
            readInfo.once().then((DataSnapshot snapshot){
              var temp2 = jsonDecode(jsonEncode(snapshot.value));
              print(temp2);
              //userAddInfo.add(Additional_Info.fromJson(temp2));
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
              List temp3 = [];
              temp3 = diseases;
              diseases.add(diseaseName);
            });
          });
        }
      });
    });
  }

  void getDoctor() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    await readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      doctor = Users.fromJson(temp1);
      doctor_ppimg = doctor.pp_img;
      pp_img = doctor.pp_img;
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
  void arrangeActive(List<Users> patients){
    List<Users> active = [];
    List<Users> hospitalized = [];
    List<Users> inactive = [];
    for(int j = 0; j < patients.length; j++){
      if(patients[j].status == "Active"){
        active.add(patients[j]);
      }
      else if (patients[j].status == "Hospitalized"){
        hospitalized.add(patients[j]);
      }
      else if(patients[j].status == "Inactive"){
        inactive.add(patients[j]);
      }
    }
    patients.clear();
    for(int i = 0; i < active.length; i++){
      patients.add(active[i]);
    }
    for(int i = 0; i < hospitalized.length; i++){
      patients.add(hospitalized[i]);
    }
    for(int i = 0; i < inactive.length; i++){
      patients.add(inactive[i]);
    }
    print("AAAAAAAAAAAAAAA");
  }

}
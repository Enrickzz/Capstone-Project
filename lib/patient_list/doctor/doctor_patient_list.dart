import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:my_app/notifications/notifications_doctor.dart';
import 'package:my_app/patient_list/doctor/doctor_add_patient.dart';
import 'package:my_app/profile/doctor/doctor_edit_management_privacy.dart';
import 'package:my_app/profile/doctor/doctor_view_patient_profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
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
  PatientList({Key key, this.title, this.nameslist, this.diseaselist, this.uidList, this.pp_img}) : super(key: key);
  final List nameslist;
  final List diseaselist;
  final List<String> uidList;
  final String title;
  final List pp_img;

  @override
  _PatientListState createState() => _PatientListState();
}
class _PatientListState extends State<PatientList>  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users doctor = new Users(email: "", firstname: "", lastname: "");
  List<Connection> doctor_connections = [];

  List<String> uidlist = [];
  List<Users> userlist=[];
  List<Additional_Info> userAddInfo =[];
  List names = [];
  List pp_imgs = [];
  List diseases=[];

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
    }
    super.initState();
    if(widget.nameslist != null){
      if(widget.nameslist.isNotEmpty){
        names = widget.nameslist;
        diseases = widget.diseaselist;
        uidlist = widget.uidList;
        pp_imgs = widget.pp_img;
      }
      print("ASDASDASD");
    }else{
      getPatients();

      isLoading = true;
    }
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
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
        ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      ): new ListView.builder(
          itemCount: names.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      // child:Image.asset("assets/images/blank_person.png",
                        child: checkimage(pp_imgs[index])),
                  ),
                  title: Text(names[index],
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
                      MaterialPageRoute(builder: (context) => view_patient_profile(userUID: uidlist[index])),
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
                MaterialPageRoute(builder: (context) => DoctorAddPatient(nameslist: names,diseaseList: diseases, uidList: uidlist, pp_img: pp_imgs)),
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

  void getPatients() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    final readDoctorConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    await readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      doctor = Users.fromJson(temp1);
      readDoctorConnections.once().then((DataSnapshot datasnapshot){
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        temp.forEach((jsonString) {
          doctor_connections.add(Connection.fromJson2(jsonString));
        });
        for(int i = 0; i < doctor_connections.length; i++){
          uidlist.add(doctor_connections[i].uid);
        }
        for(int i = 0; i < uidlist.length; i++){
          final readPatient = databaseReference.child('users/' + uidlist[i] + '/personal_info/');
          final readInfo = databaseReference.child('users/' + uidlist[i] + '/vitals/additional_info/');
          readPatient.once().then((DataSnapshot snapshot){
            var temp1 = jsonDecode(jsonEncode(snapshot.value));
            print(temp1);
            Users patient = Users.fromJson(temp1);
            //userlist.add(Users.fromJson(temp1));
            readInfo.once().then((DataSnapshot snapshot){
              var temp2 = jsonDecode(jsonEncode(snapshot.value));
              print(temp2);
              //userAddInfo.add(Additional_Info.fromJson(temp2));
              String disease_name = "";
              Additional_Info info = Additional_Info.fromJson4(temp2);
              print(info.disease.length);
              for(int j = 0; j < info.disease.length; j++){
                if(j == info.disease.length - 1){
                  print("if statement " + info.disease[j]);
                  disease_name += info.disease[j];
                }
                else{
                  print("else statement " + info.disease[j]);
                  disease_name += info.disease[j] + ", ";
                }
              }
              diseases.add(disease_name);
              print(diseases);
            });

            names.add(patient.firstname + " " + patient.lastname);
            pp_imgs.add(patient.pp_img);
          });
        }
      });
    });
    setState(() {
      isLoading = false;
      print("FIXED");
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
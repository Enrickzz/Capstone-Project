import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/doctor_add_patient.dart';
import 'package:my_app/profile/doctor_view_patient_profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';
import 'models/users.dart';


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
  PatientList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PatientListState createState() => _PatientListState();
}
class _PatientListState extends State<PatientList>  {

  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Users doctor = new Users();

  List<String> uidlist = [];

  List names = [
  //   "Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
  // "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"
  ];

  List diseases = [
    // "Bradycardia", "Cardiomyopathy", 'Heart Failure', "Coronary Heart Disease",
    // "Bradycardia", "Cardiomyopathy", 'Heart Failure', "Coronary Heart Disease", 'Heart Failure', "Coronary Heart Disease"
  ];

  @override
  void initState(){
    super.initState();
    getPatients();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {});
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
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorAddPatient()),
                    );


                    // showModalBottomSheet(context: context,
                    //   isScrollControlled: true,
                    //   builder: (context) => SingleChildScrollView(child: Container(
                    //     padding: EdgeInsets.only(
                    //         bottom: MediaQuery.of(context).viewInsets.bottom),
                    //     child: add_medication_prescription(thislist: prestemp),
                    //   ),
                    //   ),
                    // ).then((value) =>
                    //     Future.delayed(const Duration(milliseconds: 1500), (){
                    //       setState((){
                    //         print("setstate medication prescription");
                    //         print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                    //         if(value != null){
                    //           prestemp = value[0];
                    //         }
                    //       });
                    //     }));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async{
                    await _auth.signOut();
                    print('signed out');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  child: Icon(
                    Icons.audiotrack,
                  ),
                )
            ),
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
                      MaterialPageRoute(builder: (context) => view_patient_profile(patientUID: uidlist[index])),
                    );


                  }

              ),

            ),
          )

      )


    );


  }

  void getPatients() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
    readDoctor.once().then((DataSnapshot snapshot){
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      doctor = Users.fromJson2(temp1);
      for(int i = 0; i < doctor.connections.length; i++){
        uidlist.add(doctor.connections[i]);
      }
      for(int i = 0; i < uidlist.length; i++){
        final readPatient = databaseReference.child('users/' + uidlist[i] + '/personal_info/');
        final readInfo = databaseReference.child('users/' + uidlist[i] + '/vitals/additional_info/');
        readPatient.once().then((DataSnapshot snapshot){
          var temp1 = jsonDecode(jsonEncode(snapshot.value));
          print(temp1);
          Users patient = Users.fromJson(temp1);
          readInfo.once().then((DataSnapshot snapshot){
            var temp2 = jsonDecode(jsonEncode(snapshot.value));
            print(temp2);
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
          print(names);

        });
      }
    });

  }

}
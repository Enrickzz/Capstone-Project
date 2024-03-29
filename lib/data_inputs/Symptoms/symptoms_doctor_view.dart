import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/Symptoms/view_specific_symptom_doctor_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
class symptoms_doctor_view extends StatefulWidget {
  final List<Symptom> symptomlist1;
  String userUID;
  symptoms_doctor_view({Key key, this.symptomlist1, this.userUID}) : super(key: key);
  @override
  _symptomsState createState() => _symptomsState();
}

class _symptomsState extends State<symptoms_doctor_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  TimeOfDay time;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Symptom> listtemp=[];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
    listtemp.clear();
    getSymptoms();
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("setstate");
        //print(getDateFormatted(listtemp[0].symptomDate.toString()));
        print("LIST TEMP " +listtemp.length.toString());
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
          title: const Text('Symptoms', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,

        ),
        body: ListView.builder(
            itemCount: listtemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.medication_outlined ),
                    title: Text(listtemp[index].symptomName,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Intensity Level: " + listtemp[index].intensityLvl.toString(),
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${listtemp[index].symptomDate.month}/${listtemp[index].symptomDate.day}/${listtemp[index].symptomDate.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,



                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificSymptomViewAsDoctor(userUID: widget.userUID, index: index)),
                      );
                    }

                ),

              ),
            )
        )

    );
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  List<Symptom> getSymptoms() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readsymptom = databaseReference.child('users/' + userUID + '/vitals/health_records/symptoms_list/');
    List<Symptom> symptoms = [];
    symptoms.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      //print("this is temp : "+temp.toString());
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          symptoms.add(Symptom.fromJson2(jsonString));
          listtemp.add(Symptom.fromJson2(jsonString));
        }
        else{
          symptoms.add(Symptom.fromJson(jsonString));
          listtemp.add(Symptom.fromJson(jsonString));
        }
        //print(symptoms[0].symptomName);
        //print("symptoms length " + symptoms.length.toString());
      });
    });
    return symptoms;
  }
}

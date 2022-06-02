import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/laboratory_results/lab_results_patient_view.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:my_app/data_inputs/medicine_intake/medication_patient_view.dart';
import 'package:my_app/data_inputs/vitals/vitals_patient_view.dart';
import 'medicine_intake/medication_patient_view.dart';
import '../fitness_app_theme.dart';
import '../models/users.dart';
import 'package:my_app/data_inputs/supplements/supplement_prescription_view_as_patient.dart';


class data_inputs extends StatefulWidget {
  String userUID;
  data_inputs({Key key, this.userUID}) : super(key: key);
  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<data_inputs> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';
  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Symptom> thislist = new List<Symptom>();
  List<Medication> thismedlist = new List<Medication>();
  List<Medication_Prescription> prescriptionList = new List<Medication_Prescription>();
  DateFormat format = new DateFormat("MM/dd/yyyy");

  //added by borj
  List<Supplement_Prescription> supplementList = new List<Supplement_Prescription>();
  String bday= "";
  String date;
  String hours,min;
  List<Connection> connections = new List<Connection>();
  Users thisuser = new Users();  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();


  @override
  void initState(){
    initNotif();
    // print("DATE TIME " + DateTime.parse("$y-$m-$d 20:18:04Z").toString() );
    super.initState();
    setState(() {
      print("SET STATE data input");
      //convertFutureListToListSymptom();
      // convertFutureListToListMedication();
    });
  }

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Data Inputs', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
              onTap: () async {
                final User user = auth.currentUser;
                final uid = user.uid;
                final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
                Users patient = new Users();
                String contactNum="";
                await readPatient.once().then((DataSnapshot snapshotPatient) {
                  Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
                  patientTemp.forEach((key, jsonString) {
                    patient = Users.fromJson(patientTemp);
                  });
                }).then((value) async {
                  final readContactNum = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/contact_no/' /** contact_number ni SS*/);
                  await readContactNum.once().then((DataSnapshot contact) {
                    contactNum = contact.value.toString();
                  }).then((value) async{
                    print(">>>YAY");
                    await FlutterPhoneDirectCaller.callNumber(contactNum).then((value) {
                      notifySS();
                    });
                  });
                });
              },
              child: Image.asset(
                'assets/images/emergency.png',
                width: 32,
                height: 32,
              )
          ),
          SizedBox(width: 60),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => vitals()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 105,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/vitals.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: Image.asset('assets/images/vitals2.png'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Vitals',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),

                  GestureDetector(
                    onTap:(){
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => supplement_prescription(preslist: supplementList)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 105,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/vitamins.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: Image.asset('assets/images/medication2.jpg'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Supplements & Other Medicines',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),

                  GestureDetector(
                    onTap:(){
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      // thismedlist.add(new Medication(medicine_name: "tempMedicineName", medicine_type: "tempMedicineType", medicine_dosage: 2, medicine_date: format.parse("11/21/2020")));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => medication(medlist: thismedlist)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 105,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/medicine_intake.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: Image.asset('assets/images/medication2.jpg'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Medicine Intake',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      getSymptoms;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => symptoms(symptomlist1: thislist)),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 105,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/symptoms.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: Image.asset('assets/images/symptoms2.jpg'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Symptoms',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => lab_results()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 105,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/images/labresults.jpg',
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Positioned (
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        ),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    )
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: Image.asset('assets/images/labresults2.jpg'),
                                          height:30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: FitnessAppTheme.grey.withOpacity(1),
                                                    offset: Offset(1.1, 1.5),
                                                    blurRadius: 100.0),
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          'Laboratory Results',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Symptom>> getSymptoms () async {
    List<Symptom> symptomsList = new List<Symptom>();
    final User user = auth.currentUser;
    final uid = user.uid;
    final symptomsRef = databaseReference.child('users/' + uid +'/symptoms_list/');
    int tempIntesityLvl = 0;
    String tempSymptomName = "";
    String tempSymptomDate = "";
    String tempSymptomFelt = "";
    await symptomsRef.once().then((DataSnapshot datasnapshot){
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Symptom symptom;

      for(var i = 0; i < temp.length; i++){
        String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 4){
          switch(i){
            case 0: {
              tempIntesityLvl = int.parse(splitFull.last);
            }
            break;
            case 1: {
              tempSymptomName = splitFull.last;
            }
            break;
            case 2: {
              tempSymptomDate = splitFull.last;
            }
            break;
            case 3: {
              tempSymptomFelt = splitFull.last;
              // symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date:format.parse(tempSymptomDate));
              symptomsList.add(symptom);
            }
            break;
          }
        }
        else{
          switch(i%4){
            case 0: {
              tempIntesityLvl = int.parse(splitFull.last);
            }
            break;
            case 1: {
              tempSymptomName = splitFull.last;
            }
            break;
            case 2: {
              tempSymptomDate = splitFull.last;

            }
            break;
            case 3: {
              tempSymptomFelt = splitFull.last;
              // symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: format.parse(tempSymptomDate));
              symptomsList.add(symptom);

            }
            break;
          }
        }
      }
      for(var i=0;i<symptomsList.length/2;i++){
        var temp = symptomsList[i];
        symptomsList[i] = symptomsList[symptomsList.length-1-i];
        symptomsList[symptomsList.length-1-i] = temp;
      }
    });
    return symptomsList;
  }
  void notifySS(){
    final User user = auth.currentUser;
    final uid = user.uid;
    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readConnections.once().then((DataSnapshot snapshot2) {
      print(snapshot2.value);
      print("CONNECTION");
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
      temp.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString)) ;
        Connection a = Connection.fromJson(jsonString);
        print(a.doctor1);
        var readUser = databaseReference.child("users/" + a.doctor1 + "");
        Users checkSS = new Users();
        readUser.once().then((DataSnapshot snapshot){
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          temp.forEach((key, jsonString) {
            checkSS = Users.fromJson(temp);
          });
          if(checkSS.usertype=="Family member / Caregiver" || checkSS.usertype =="Doctor"){
            addtoNotif("Your <type> "+ thisuser.firstname+ " has used his panic button! Check on the patient immediately",
                thisuser.firstname + " used SOS!",
                "3",
                a.doctor1,
                "SOS", "",
                date ,
                hours.toString() +":"+min.toString());
          }
        });
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect,String category, String date, String time){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) async{
      await getNotifs2(uid).then((value) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
          ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }
      });

    });
  }
  Future<void> getNotifs2(String passedUid) async {
    notifsList.clear();
    final uid = passedUid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
    });
  }
  Future<List<Medication>> getMedication() async {
    List<Medication> medicationList = new List<Medication>();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list');
    String tempMedicineName = "";
    String tempMedicineType = "";
    String tempMedicineDate = "";
    double tempMedicineDosage = 0;
    await readMedication.once().then((DataSnapshot datasnapshot) {
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Medication medicine;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 4){
          print("i value" + i.toString());
          switch(i){
            case 0: {
              print("1st switch i = 0 " + splitFull.last);
              // tempMedicineDosage = double.parse(splitFull.last);
              tempMedicineType = splitFull.last;

            }
            break;
            case 1: {
              print("1st switch i = 1 " + splitFull.last);
              tempMedicineDosage = double.parse(splitFull.last);

            }
            break;
            case 2: {
              print("1st switch i = 2 " + splitFull.last);
              tempMedicineDate = splitFull.last;
            }
            break;
            case 3: {
              print("1st switch i = 3 " + splitFull.last);
              tempMedicineName = splitFull.last;
              medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: format.parse(tempMedicineDate));
              medicationList.add(medicine);
            }
            break;
          }
        }
        else{
          print("i value" + i.toString());
          print("i value modulu " + (i%4).toString());
          switch(i%4){
            case 0: {
              print("2nd switch intensity lvl " + splitFull.last);

              tempMedicineType = splitFull.last;
              // tempMedicineDosage = 0;
            }
            break;
            case 1: {
              print("2nd switch symptom name " + splitFull.last);
              tempMedicineDosage = double.parse(splitFull.last);

            }
            break;
            case 2: {
              print("2nd switch symptom date " + splitFull.last);
              tempMedicineDate = splitFull.last;

            }
            break;
            case 3: {
              print("2nd switch symptom felt " + splitFull.last);
              tempMedicineName = splitFull.last;
              medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: format.parse(tempMedicineDate));
              medicationList.add(medicine);
            }
            break;
          }
        }
      }
      for(var i=0;i<medicationList.length/2;i++){
        var temp = medicationList[i];
        medicationList[i] = medicationList[medicationList.length-1-i];
        medicationList[medicationList.length-1-i] = temp;
      }

    });
    return medicationList;
  }
  void convertFutureListToListSymptom() async {
    Future<List> _futureOfList = getSymptoms();
    List list = await _futureOfList ;
    thislist = list;
  }
  void convertFutureListToListMedication() async {
    Future<List> _futureOfList = getMedication();
    List list = await _futureOfList ;
    thismedlist = list;
  }

}

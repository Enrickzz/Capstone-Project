import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/data_inputs/lab_results.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import 'package:my_app/data_inputs/medication.dart';
import 'package:my_app/data_inputs/vitals/vitals.dart';
import 'data_inputs/medication.dart';
import 'fitness_app_theme.dart';
import 'models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class data_inputs extends StatefulWidget {
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
  DateFormat format = new DateFormat("MM/dd/yyyy");

  @override
  void initState(){
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
      ),
      body: SingleChildScrollView(
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
                    getSymptoms;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => symptoms(symptomlist1: thislist)),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                      height: 140,
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
                              height: 120,
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
                      height: 140,
                      child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset('assets/images/medication.jpg',
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            Positioned (
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 120,
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
                                        'Medication Intake',
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
                      height: 140,
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
                                  height: 120,
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
                GestureDetector(
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => vitals()),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                      height: 140,
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
                                  height: 120,
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
                                        'Recorded Vitals',
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
              symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date:format.parse(tempSymptomDate));
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
              symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: format.parse(tempSymptomDate));
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

  Future<List<Medication>> getMedication() async {
    List<Medication> medication_list = new List<Medication>();
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
              medication_list.add(medicine);
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
              medication_list.add(medicine);
            }
            break;
          }
        }
      }
      for(var i=0;i<medication_list.length/2;i++){
        var temp = medication_list[i];
        medication_list[i] = medication_list[medication_list.length-1-i];
        medication_list[medication_list.length-1-i] = temp;
      }

    });
    return medication_list;
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

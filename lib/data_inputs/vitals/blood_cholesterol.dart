import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../../fitness_app_theme.dart';
import 'add_blood_cholesterol.dart';
import 'add_blood_pressure.dart';
import 'add_o2_saturation.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class blood_cholesterol extends StatefulWidget {
  final List<Blood_Cholesterol> bclist;
  blood_cholesterol({Key key, this.bclist}): super(key: key);
  @override
  _blood_cholesterolState createState() => _blood_cholesterolState();
}

class _blood_cholesterolState extends State<blood_cholesterol> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Cholesterol> bctemp = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readCholesterol = databaseReference.child('users/' + uid + '/vitals/health_records/blood_cholesterol_list');
    String tempTotalCholesterol = "";
    String tempLdlCholesterol = "";
    String tempHdlCholesterol = "";
    String tempTriglycerides = "";
    String tempCholesterolDate;
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readCholesterol.once().then((DataSnapshot datasnapshot) {
      bctemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Blood_Cholesterol cholesterol;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        switch(i%5){
          case 0: {
            tempTotalCholesterol = splitFull.last;
          }
          break;
          case 1: {
            tempCholesterolDate = splitFull.last;
          }
          break;
          case 2: {
            tempTriglycerides = splitFull.last;
          }
          break;
          case 3: {
            tempLdlCholesterol = splitFull.last;
          }
          break;
          case 4: {
            tempHdlCholesterol = splitFull.last;
            cholesterol = new Blood_Cholesterol(total_cholesterol: double.parse(tempTotalCholesterol), ldl_cholesterol: double.parse(tempLdlCholesterol), hdl_cholesterol: double.parse(tempHdlCholesterol),triglycerides: double.parse(tempTriglycerides), cholesterol_date: format.parse(tempCholesterolDate));
            bctemp.add(cholesterol);
          }
          break;
        }

      }
      for(var i=0;i<bctemp.length/2;i++){
        var temp = bctemp[i];
        bctemp[i] = bctemp[bctemp.length-1-i];
        bctemp[bctemp.length-1-i] = temp;
      }
    });
    bctemp = widget.bclist;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
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
        title: const Text('Blood Cholesterol Level', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: add_blood_cholesterol(cholList: bctemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      bctemp = value;
                    }
                    print("BCTEMP LENGTH AFTER SETSTATE  =="  + bctemp.length.toString() );
                  }));
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bctemp.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 140,
                child: Stack(
                    children: [
                      Positioned (
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.7),
                                      Colors.white
                                    ]
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(0.6),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ]
                            )
                        ),
                      ),
                      Positioned(
                        top: 25,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [

                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '' + bctemp[index].getDate.toString()+" \n"
                                      + "TOTAL: " +bctemp[index].getTotalCholesterol.toString()+ " mmol/l"+
                                      "\nHDL: " + bctemp[index].gethdlCholesterol.toString() + " mmol/l"+ " \n"
                                      "LDL: "+ bctemp[index].getldlCholesterol.toString()+  " mmol/l"+" \n" +
                                      "TRI: "+ bctemp[index].getTriglycerides.toString()+ " mmol/l",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  )
                              ),

                            ],
                          ),
                        ),
                      ),
                    ]
                )
            ),
          );
        },
      ),

    );
  }
}
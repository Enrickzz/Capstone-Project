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
import 'add_blood_pressure.dart';
import 'add_o2_saturation.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class o2_saturation extends StatefulWidget {
  final List<Oxygen_Saturation> oxygenlist;
  o2_saturation({Key key, this.oxygenlist}): super(key: key);
  @override
  _o2_saturationState createState() => _o2_saturationState();
}

class _o2_saturationState extends State<o2_saturation> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Oxygen_Saturation> oxygentemp = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readOxygen = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list');
    String tempOxygen = "";
    String tempOxygenDate = "";
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readOxygen.once().then((DataSnapshot datasnapshot) {
      oxygentemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Oxygen_Saturation oxygen;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 2){
          switch(i){
            case 0: {
              tempOxygen = splitFull.last;
            }
            break;
            case 1: {
              tempOxygenDate = splitFull.last;
              oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen), os_date: format.parse(tempOxygenDate));
              oxygentemp.add(oxygen);
            }
            break;
          }
        }
        else{
          switch(i%2){
            case 0: {
              tempOxygen = splitFull.last;
            }
            break;
            case 1: {
              tempOxygenDate = splitFull.last;
              oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen), os_date: format.parse(tempOxygenDate));
              oxygentemp.add(oxygen);
            }
            break;
          }
        }
      }
      for(var i=0;i<oxygentemp.length/2;i++){
        var temp = oxygentemp[i];
        oxygentemp[i] = oxygentemp[oxygentemp.length-1-i];
        oxygentemp[oxygentemp.length-1-i] = temp;
      }
    });
    oxygentemp = widget.oxygenlist;
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
        title: const Text('Oxygen Saturation', style: TextStyle(
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
                      child: add_o2_saturation(),
                    ),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),

    );
  }
}
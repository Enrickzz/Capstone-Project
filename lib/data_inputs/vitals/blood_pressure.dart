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
import 'add_blood_pressure.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class blood_pressure extends StatefulWidget {
  final List<Blood_Pressure> bplist;
  blood_pressure({Key key, this.bplist}): super(key: key);
  @override
  _blood_pressureState createState() => _blood_pressureState();
}

class _blood_pressureState extends State<blood_pressure> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Pressure> bptemp = [];
  TimeOfDay time;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState(){
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list');
    String tempSystolicPressure = "";
    String tempDiastolicPressure = "";
    String tempBPDate = "";
    String tempBPTime = "";
    String tempBPLvl = "";
    readBP.once().then((DataSnapshot datasnapshot) {
      bptemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Blood_Pressure blood_pressure = new Blood_Pressure();
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 5){
          switch(i){
            case 0: {
              print("i is " + i.toString() + splitFull.last);
              tempBPDate = splitFull.last;
            }
            break;
            case 1: {
              print("i is " + i.toString() + splitFull.last);
              tempDiastolicPressure = splitFull.last;
            }
            break;
            case 2: {
              print("i is " + i.toString() + splitFull.last);

              tempBPLvl = splitFull.last;
            }
            break;
            case 3: {
              print("i is " + i.toString() + splitFull.last);
              tempBPTime = splitFull.last;
            }
            break;
            case 4: {
              print("i is " + i.toString() + splitFull.last);
              tempSystolicPressure = splitFull.last;
              blood_pressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure,pressure_level: tempBPLvl, bp_date: format.parse(tempBPDate), bp_time: timeformat.parse(tempBPTime));
              bptemp.add(blood_pressure);
            }
            break;
          }
        }
        else{
          switch(i%5){
            case 0: {
              print("i is " + i.toString() + splitFull.last);
              tempBPDate = splitFull.last;
            }
            break;
            case 1: {
              print("i is " + i.toString() + splitFull.last);
              tempDiastolicPressure = splitFull.last;
            }
            break;
            case 2: {
              print("i is " + i.toString() + splitFull.last);
              tempBPLvl = splitFull.last;
            }
            break;
            case 3: {
              print("i is " + i.toString() + splitFull.last);
              tempBPTime = splitFull.last;
            }
            break;
            case 4: {
              print("i is " + i.toString() + splitFull.last);
              tempSystolicPressure = splitFull.last;
              blood_pressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure,pressure_level: tempBPLvl, bp_date: format.parse(tempBPDate), bp_time: timeformat.parse(tempBPTime));
              bptemp.add(blood_pressure);
            }
            break;
          }
        }
      }
      for(var i=0;i<bptemp.length/2;i++){
        var temp = bptemp[i];
        bptemp[i] = bptemp[bptemp.length-1-i];
        bptemp[bptemp.length-1-i] = temp;
      }
    });
    bptemp = widget.bplist;
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print(bptemp);
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
        title: const Text('Blood Pressure', style: TextStyle(
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
                      child: add_blood_pressure(thislist: bptemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate blood_pressure");
                    if(value != null){
                      bptemp = value;
                    }
                  }));
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),
<<<<<<< Updated upstream
      body: ListView.builder(
      itemCount: bptemp.length,
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
                                '' + getDateFormatted(bptemp[index].getDate.toString())+getTimeFormatted(bptemp[index].getTime.toString())+" " + bptemp[index].getLvl_pres.toString()
                                    +"\nBlood pressure: "+ bptemp[index].getSys_pres + "/" + bptemp[index].getDia_pres.toString(),
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
=======
    body:buildDataTable(),
    //   body: ListView.builder(
    //   itemCount: bptemp.length,
    //   itemBuilder: (context, index) {
    //     return GestureDetector(
    //       child: Container(
    //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //           height: 140,
    //           child: Stack(
    //               children: [
    //                 Positioned (
    //                   bottom: 0,
    //                   left: 0,
    //                   right: 0,
    //                   child: Container(
    //                       height: 120,
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.only(
    //                               bottomLeft: Radius.circular(20),
    //                               topLeft: Radius.circular(20),
    //                               topRight: Radius.circular(20),
    //                               bottomRight: Radius.circular(20)
    //                           ),
    //                           gradient: LinearGradient(
    //                               begin: Alignment.bottomCenter,
    //                               end: Alignment.topCenter,
    //                               colors: [
    //                                 Colors.white.withOpacity(0.7),
    //                                 Colors.white
    //                               ]
    //                           ),
    //                           boxShadow: <BoxShadow>[
    //                             BoxShadow(
    //                                 color: FitnessAppTheme.grey.withOpacity(0.6),
    //                                 offset: Offset(1.1, 1.1),
    //                                 blurRadius: 10.0),
    //                           ]
    //                       )
    //                   ),
    //                 ),
    //                 Positioned(
    //                   top: 25,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(10),
    //                     child: Row(
    //                       children: [
    //
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Text(
    //                             '' + getDateFormatted(bptemp[index].getDate.toString())+getTimeFormatted(bptemp[index].getTime.toString())+" "
    //                                 +"\nBlood pressure: "+ bptemp[index].getSys_pres + "/" + bptemp[index].getDia_pres.toString(),
    //                             style: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 18
    //                             )
    //                         ),
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ]
    //           )
    //       ),
    //     );
    //   },
    // ),
>>>>>>> Stashed changes

    );
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }

<<<<<<< Updated upstream

=======
  Widget buildDataTable(){
    final columns = ['Date', 'Time', 'Blood Pressure', 'Indication'];

    return DataTable(
      columns: getColumns(columns),
 

    );

  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
      label: Text(column),
  ) )
      .toList();
>>>>>>> Stashed changes

}
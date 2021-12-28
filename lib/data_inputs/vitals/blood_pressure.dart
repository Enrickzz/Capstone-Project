import 'dart:convert';

import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms.dart';
import '../../fitness_app_theme.dart';
import 'add_blood_pressure.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
import 'package:collection/collection.dart';


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
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];


  @override
  void initState(){
    super.initState();
    bptemp.clear();
    _selected.clear();
    getBloodPressure();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list');
    // String tempSystolicPressure = "";
    // String tempDiastolicPressure = "";
    // String tempBPDate = "";
    // String tempBPTime = "";
    // String tempBPLvl = "";
    // readBP.once().then((DataSnapshot datasnapshot) {
    //
    //   String temp1 = datasnapshot.value.toString();
    //   List<String> temp = temp1.split(',');
    //   Blood_Pressure blood_pressure = new Blood_Pressure();
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //     switch(i%5){
    //       case 0: {
    //         print("i is " + i.toString() + splitFull.last);
    //         tempBPDate = splitFull.last;
    //       }
    //       break;
    //       case 1: {
    //         print("i is " + i.toString() + splitFull.last);
    //         tempDiastolicPressure = splitFull.last;
    //       }
    //       break;
    //       case 2: {
    //         print("i is " + i.toString() + splitFull.last);
    //         tempBPLvl = splitFull.last;
    //       }
    //       break;
    //       case 3: {
    //         print("i is " + i.toString() + splitFull.last);
    //         tempBPTime = splitFull.last;
    //       }
    //       break;
    //       case 4: {
    //         print("i is " + i.toString() + splitFull.last);
    //         tempSystolicPressure = splitFull.last;
    //         blood_pressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure,pressure_level: tempBPLvl, bp_date: format.parse(tempBPDate), bp_time: timeformat.parse(tempBPTime));
    //         bptemp.add(blood_pressure);
    //       }
    //       break;
    //     }
    //
    //   }
    //   for(var i=0;i<bptemp.length/2;i++){
    //     var temp = bptemp[i];
    //     bptemp[i] = bptemp[bptemp.length-1-i];
    //     bptemp[bptemp.length-1-i] = temp;
    //   }
    // });
    // _selected = List<bool>.generate(bptemp.length, (int index) => false);
    // bptemp = widget.bplist;
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        _selected = List<bool>.generate(bptemp.length, (int index) => false);

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
          GestureDetector(
            onTap: () {
              // showModalBottomSheet(context: context,
              //   isScrollControlled: true,
              //   builder: (context) => SingleChildScrollView(child: Container(
              //     padding: EdgeInsets.only(
              //         bottom: MediaQuery.of(context).viewInsets.bottom),
              //     child: add_blood_pressure(thislist: bptemp),
              //   ),
              //   ),
              // ).then((value) => setState((){
              //   print("setstate blood_pressure");
              //   if(value != null){
              //     bptemp = value;
              //     _selected = List<bool>.generate(bptemp.length, (int index) => false);
              //
              //   }
              // }));
            },
            child: Icon(
              Icons.delete,
            ),
          ),
          SizedBox(width: 10),
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
                      _selected = List<bool>.generate(bptemp.length, (int index) => false);

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
         body: SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Scrollbar(
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: _createDataTable()

             ),
           ),





         ),

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
    //                             '' + getDateFormatted(bptemp[index].getDate.toString())+getTimeFormatted(bptemp[index].getTime.toString())+" " + bptemp[index].getLvl_pres.toString()
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

  Color getMyColor(String indication) {
    if(indication == 'normal'){
      return Colors.green;
    }
    else if(indication == 'low'){
      return Colors.blue;

    }
    else
      return Colors.red;

  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
      dividerThickness: 5,
      dataRowHeight: 80,
      showBottomBorder: true,
      headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
      headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.lightBlue
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text('Date'),
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              bptemp.sort((a, b) => b.bp_date.compareTo(a.bp_date));
            } else {
              bptemp.sort((a, b) => a.bp_date.compareTo(b.bp_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Blood Pressure')),
      DataColumn(label: Text('Implication'))

    ];

  }

  // List<DataRow> _createRows() {
  //
  //   return bptemp
  //       .mapIndexed((index,bp) => DataRow(cells: [
  //
  //           DataCell(Text(getDateFormatted(bp.getDate.toString()))),
  //           DataCell(Text(getTimeFormatted(bp.getTime.toString()))),
  //           DataCell(Text(bp.getSys_pres +'/'+ bp.getDia_pres, style: TextStyle(),)),
  //           DataCell(Text(bp.getLvl_pres, style: TextStyle(color: getMyColor(bp.getLvl_pres)),))
  //
  //
  //   ],
  //       selected:  _selected[index],
  //       onSelectChanged: (bool selected){
  //         setState(() {
  //           _selected[index] = selected;
  //         });
  //       }
  //
  //   )).toList();
  // }
  List<DataRow> _createRows() {
    return bptemp
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.bp_date.toString()))),
          DataCell(Text(getTimeFormatted(bp.bp_time.toString()))),
          DataCell(Text(bp.systolic_pressure +'/'+ bp.diastolic_pressure, style: TextStyle(),)),
          DataCell(Text(bp.pressure_level, style: TextStyle(color: getMyColor(bp.pressure_level)),))
        ],
        selected: _selected[index],
        onSelectChanged: (bool selected) {
          setState(() {
            _selected[index] = selected;
          });
        }))
        .toList();
  }
  void getBloodPressure() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bptemp.add(Blood_Pressure.fromJson(jsonString));
      });
    });
  }


}
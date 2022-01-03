import 'dart:convert';
import 'dart:io';
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
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../../fitness_app_theme.dart';
import '../blood_pressure/add_blood_pressure.dart';
import '../../laboratory_results/add_lab_results.dart';
import '../../medicine_intake/add_medication.dart';
import 'add_body_temperature.dart';
import 'edit_body_temperature.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class body_temperature extends StatefulWidget {
  final List<Body_Temperature> btlist;
  body_temperature({Key key, this.btlist}): super(key: key);
  @override
  _body_temperatureState createState() => _body_temperatureState();
}

class _body_temperatureState extends State<body_temperature> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Body_Temperature> bttemp = [];
  List<File> _image = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    bttemp.clear();
    _selected.clear();
    getBodyTemp();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final readTemperature = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list');
    // String tempUnit = "";
    // String tempTemperature = "";
    // String tempTemperatureDate = "";
    // String tempTemperatureTime = "";
    //
    //
    // readTemperature.once().then((DataSnapshot datasnapshot) {
    //
    //   String temp1 = datasnapshot.value.toString();
    //   List<String> temp = temp1.split(',');
    //   Body_Temperature bodyTemperature;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //     switch(i%4){
    //       case 0: {
    //         print("i is "+ i.toString() + splitFull.last);
    //         tempUnit = splitFull.last;
    //       }
    //       break;
    //       case 1: {
    //         print("i is "+ i.toString() + splitFull.last);
    //         tempTemperatureDate = splitFull.last;
    //       }
    //       break;
    //       case 2: {
    //         print("i is "+ i.toString() + splitFull.last);
    //         tempTemperature = splitFull.last;
    //       }
    //       break;
    //       case 3: {
    //         print("i is "+ i.toString() + splitFull.last);
    //         tempTemperatureTime = splitFull.last;
    //         bodyTemperature = new Body_Temperature(unit: tempUnit, temperature: double.parse(tempTemperature),bt_date: format.parse(tempTemperatureDate), bt_time: timeformat.parse(tempTemperatureTime));
    //         bttemp.add(bodyTemperature);
    //       }
    //       break;
    //     }
    //   }
    //   for(var i=0;i<bttemp.length/2;i++){
    //     var temp = bttemp[i];
    //     bttemp[i] = bttemp[bttemp.length-1-i];
    //     bttemp[bttemp.length-1-i] = temp;
    //   }
    // });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(bttemp.length, (int index) => false);

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
        title: const Text('Body Temperature', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              _showMyDialogDelete();
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
                      child: add_body_temperature(btlist: bttemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      bttemp = value;
                      _selected = List<bool>.generate(bttemp.length, (int index) => false);

                    }
                    print("SYMP LENGTH AFTER SETSTATE  =="  + bttemp.length.toString() );
                  }));;
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
    // itemCount: bttemp.length,
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
    //                         FlatButton(
    //                           child: Text(
    //                             'Edit',
    //                             style: TextStyle(color: Colors.white),
    //                           ),
    //                           color: Colors.black,
    //                           onPressed: () {
    //                             showModalBottomSheet(context: context,
    //                               isScrollControlled: true,
    //                               builder: (context) => SingleChildScrollView(child: Container(
    //                                 padding: EdgeInsets.only(
    //                                     bottom: MediaQuery.of(context).viewInsets.bottom),
    //                                 child: edit_body_temperature(bt: bttemp[index], pointer: index,),
    //                               ),
    //                               ),
    //                             ).then((value) => setState((){
    //                               print("setstate symptoms");
    //                               if(value != null){
    //                                 bttemp = value;
    //                               }
    //                               print("SYMP LENGTH AFTER SETSTATE  =="  + bttemp.length.toString() );
    //                             }));;
    //                           },
    //                         ),
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Text(
    //                             '' + getDateFormatted(bttemp[index].bt_date.toString()) + getTimeFormatted(bttemp[index].bt_time.toString())+" "
    //                                 +"\nTemperature: "+ bttemp[index].temperature.toString() + " " + bttemp[index].unit+ " ",
    //                             style: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 18
    //                             )
    //                         ),
    //
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
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  void getBodyTemp() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBT = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
    readBT.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bttemp.add(Body_Temperature.fromJson(jsonString));
      });

    });
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
              bttemp.sort((a, b) => b.bt_date.compareTo(a.bt_date));
            } else {
              bttemp.sort((a, b) => a.bt_date.compareTo(b.bt_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Blood Temperature')),
      // DataColumn(label: Text('Implication'))

    ];

  }

  List<DataRow> _createRows() {
    return bttemp
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.bt_date.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(bp.temperature.toString() +'°C', style: TextStyle(),)),
          // DataCell(Text(bp.pressure_level, style: TextStyle(color: getMyColor(bp.pressure_level)),))
        ],
        selected: _selected[index],
        onSelectChanged: (bool selected) {
          setState(() {
            _selected[index] = selected;
          });
        }))
        .toList();
  }
  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete these record/s?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                print('Deleted');
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
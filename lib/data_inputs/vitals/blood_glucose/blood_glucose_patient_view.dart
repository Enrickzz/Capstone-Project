import 'dart:convert';

import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'add_blood_glucose.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class blood_glucose extends StatefulWidget {
  final List<Blood_Glucose> bglist;
  blood_glucose({Key key, this.bglist}): super(key: key);
  @override
  _blood_glucoseState createState() => _blood_glucoseState();
}

class _blood_glucoseState extends State<blood_glucose> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Glucose> bgtemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
      bgtemp.clear();
    _selected.clear();
    getBloodGlucose();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
    // String tempGlucose = "";
    // String tempStatus = "";
    // String tempGlucoseStatus = "";
    // String tempGlucoseDate = "";
    // String tempGlucoseTime = "";
    // readMedication.once().then((DataSnapshot datasnapshot) {

    //   String temp1 = datasnapshot.value.toString();
    //   print("temp1 " + temp1);
    //   List<String> temp = temp1.split(',');
    //   Blood_Glucose bloodGlucose;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //     switch(i%5){
    //       case 0: {
    //         tempGlucose = splitFull.last;
    //       }
    //       break;
    //       case 1: {
    //         tempGlucoseTime = splitFull.last;
    //       }
    //       break;
    //       case 2: {
    //         tempStatus = splitFull.last;
    //       }
    //       break;
    //       case 3: {
    //         tempGlucoseStatus = splitFull.last;
    //       }
    //       break;
    //       case 4: {
    //         tempGlucoseDate = splitFull.last;
    //         bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), bloodGlucose_unit: tempStatus, bloodGlucose_status: tempGlucoseStatus, bloodGlucose_date: format.parse(tempGlucoseDate),bloodGlucose_time: timeformat.parse(tempGlucoseTime));
    //         bgtemp.add(bloodGlucose);
    //       }
    //       break;
    //     }
    //
    //   }
    //   for(var i=0;i<bgtemp.length/2;i++){
    //     var temp = bgtemp[i];
    //     bgtemp[i] = bgtemp[bgtemp.length-1-i];
    //     bgtemp[bgtemp.length-1-i] = temp;
    //   }
    // });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(bgtemp.length, (int index) => false);

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
        title: const Text('Blood Glucose Level', style: TextStyle(
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
                      child: add_blood_glucose(thislist: bgtemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      bgtemp = value;
                    }
                    print("BGTEMP LENGTH AFTER SETSTATE  =="  + bgtemp.length.toString() );
                    setState(() {
                      _selected = List<bool>.generate(bgtemp.length, (int index) => false);
                    });
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

    );
  }
  String getDateFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }
  }
  void getBloodGlucose() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bgtemp.add(Blood_Glucose.fromJson(jsonString));
      });
    });
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
                final User user = auth.currentUser;
                final uid = user.uid;
                int initialLength = bgtemp.length;
                List<int> deleteList = [];
                for(int i = 0; i < bgtemp.length; i++){
                  if(_selected[i]){
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a,b) => b.compareTo(a));
                for(int i = 0; i < deleteList.length; i++){
                  bgtemp.removeAt(deleteList[i]);
                }
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + i.toString());
                  bpRef.remove();
                }
                for(int i = 0; i < bgtemp.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + (i+1).toString());
                  bpRef.set({
                    "glucose": bgtemp[i].glucose.toString(),
                    "lastMeal": bgtemp[i].lastMeal.toString(),
                    "glucose_status": bgtemp[i].bloodGlucose_status.toString(),
                    "bloodGlucose_date": "${bgtemp[i].bloodGlucose_date.month.toString().padLeft(2,"0")}/${bgtemp[i].bloodGlucose_date.day.toString().padLeft(2,"0")}/${bgtemp[i].bloodGlucose_date.year}",
                    "bloodGlucose_time": "${bgtemp[i].bloodGlucose_time.hour.toString().padLeft(2,"0")}:${bgtemp[i].bloodGlucose_time.minute.toString().padLeft(2,"0")}"
                  });
                }
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
      columnSpacing: 35,
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
              bgtemp.sort((a, b) => b.bloodGlucose_date.compareTo(a.bloodGlucose_date));
            } else {
              bgtemp.sort((a, b) => a.bloodGlucose_date.compareTo(b.bloodGlucose_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Blood Glucose')),
      DataColumn(label: Text('Last Meal')),
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
    return bgtemp
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.bloodGlucose_date.toString()))),
          DataCell(Text(getTimeFormatted(bp.bloodGlucose_time.toString()))),
          DataCell(Text(bp.glucose.toStringAsFixed(1) +' mg/dL', style: TextStyle(),)),
          DataCell(Text(bp.lastMeal.toString() + ' hr/s ago' , style: TextStyle(),)),
          DataCell(Text(bp.bloodGlucose_status, style: TextStyle(color: getMyColor(bp.bloodGlucose_status)),))
        ],
        selected: _selected[index],
        onSelectChanged: (bool selected) {
          setState(() {
            _selected[index] = selected;
          });
        }))
        .toList();
  }
}
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/add_blood_pressure.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
import 'package:collection/collection.dart';


class blood_pressure_doctor_view extends StatefulWidget {
  final List<Blood_Pressure> bplist;
  final String userUID;
  blood_pressure_doctor_view({Key key, this.bplist, this.userUID}): super(key: key);
  @override
  _blood_pressureDoctorState createState() => _blood_pressureDoctorState();
}

class _blood_pressureDoctorState extends State<blood_pressure_doctor_view> {
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
          Visibility(
              visible: true, //TRUE OR FALSE IF ACCESS IS GIVEN
              child: GestureDetector(
                onTap: () {
                  _showMyDialogDelete();
                },
                child: Icon(
                  Icons.delete,
                ),
              )),
          SizedBox(width: 10),
          Visibility(
              visible: true, //TRUE OR FALSE IF ACCESS IS GIVEN
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                MediaQuery.of(context).viewInsets.bottom),
                            child: add_blood_pressure(
                                thislist: bptemp, userUID: widget.userUID),
                          ),
                        ),
                      ).then((value) => setState(() {
                        print("setstate blood_pressure");
                        if (value != null) {
                          bptemp = value;
                          _selected = List<bool>.generate(
                              bptemp.length, (int index) => false);
                        }
                      }));
                    },
                    child: Icon(
                      Icons.add,
                    ),
                  ))),
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
  Color getMyColor2(String indication) {
    if(indication == 'Active'){
      return Colors.red;
    }
    else if(indication == 'Resting'){
      return Colors.blue;
    }
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
      DataColumn(label: Text('Implication')),
      DataColumn(label: Text('Status'))

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
          DataCell(Text(bp.pressure_level, style: TextStyle(color: getMyColor(bp.pressure_level)),)),
          DataCell(Text(bp.bp_status, style: TextStyle(color: getMyColor2(bp.bp_status)),))

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
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    print("USERUID");
    print(userUID);
    final readBP = databaseReference.child('users/' + userUID + '/vitals/health_records/bp_list/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bptemp.add(Blood_Pressure.fromJson(jsonString));
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
                // final User user = auth.currentUser;
                // final uid = user.uid;
                String userUID = widget.userUID;
                int initialLength = bptemp.length;
                List<int> deleteList = [];
                for(int i = 0; i < bptemp.length; i++){
                  if(_selected[i]){
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a,b) => b.compareTo(a));
                for(int i = 0; i < deleteList.length; i++){
                  bptemp.removeAt(deleteList[i]);
                }
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/bp_list/' + i.toString());
                  bpRef.remove();
                }
                for(int i = 0; i < bptemp.length; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/bp_list/' + (i+1).toString());
                  bpRef.set({
                    "systolic_pressure": bptemp[i].systolic_pressure.toString(),
                    "diastolic_pressure": bptemp[i].diastolic_pressure.toString(),
                    "pressure_level": bptemp[i].pressure_level.toString(),
                    "bp_date": "${bptemp[i].bp_date.month.toString().padLeft(2,"0")}/${bptemp[i].bp_date.day.toString().padLeft(2,"0")}/${bptemp[i].bp_date.year}",
                    "bp_time": "${bptemp[i].bp_time.hour.toString().padLeft(2,"0")}:${bptemp[i].bp_time.minute.toString().padLeft(2,"0")}",
                    "bp_status": bptemp[i].bp_status.toString()
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


}
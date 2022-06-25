import 'dart:convert';
import 'dart:io';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/body_temperature/add_body_temperature.dart';
import 'package:my_app/models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class body_temperature_doctor_view extends StatefulWidget {
  final List<Body_Temperature> btlist;
  final String userUID;
  body_temperature_doctor_view({Key key, this.btlist, this.userUID}): super(key: key);
  @override
  _body_temperatureDoctorState createState() => _body_temperatureDoctorState();
}

class _body_temperatureDoctorState extends State<body_temperature_doctor_view> {
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
                            child: add_body_temperature(
                                btlist: bttemp, userUID: widget.userUID),
                          ),
                        ),
                      ).then((value) => setState(() {
                        print("setstate blood_pressure");
                        if (value != null) {
                          bttemp = value;
                          _selected = List<bool>.generate(
                              bttemp.length, (int index) => false);
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
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  void getBodyTemp() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readBT = databaseReference.child('users/' + userUID + '/vitals/health_records/body_temperature_list/');
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
    else if(indication == 'low grade fever'){
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
              bttemp.sort((a, b) => b.bt_date.compareTo(a.bt_date));
            } else {
              bttemp.sort((a, b) => a.bt_date.compareTo(b.bt_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label:  Icon(Icons.access_time, color: Colors.white,),),
      DataColumn(label:  Icon(Icons.device_thermostat , color: Colors.white,),),
      DataColumn(label: Text('Implication'))

    ];

  }

  List<DataRow> _createRows() {
    return bttemp
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.bt_date.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(bp.temperature.toString() +'°C', style: TextStyle(),)),
          DataCell(Text(bp.indication, style: TextStyle(color: getMyColor(bp.indication)),))
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
                // final User user = auth.currentUser;
                // final uid = user.uid;
                String userUID = widget.userUID;
                int initialLength = bttemp.length;
                List<int> deleteList = [];
                for(int i = 0; i < bttemp.length; i++){
                  if(_selected[i]){
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a,b) => b.compareTo(a));
                for(int i = 0; i < deleteList.length; i++){
                  bttemp.removeAt(deleteList[i]);
                }
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/body_temperature_list/' + i.toString());
                  bpRef.remove();
                }
                for(int i = 0; i < bttemp.length; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/body_temperature_list/' + (i+1).toString());
                  bpRef.set({
                    "unit": bttemp[i].unit.toString(),
                    "temperature": bttemp[i].temperature.toString(),
                    "bt_date": "${bttemp[i].bt_date.month.toString().padLeft(2,"0")}/${bttemp[i].bt_date.day.toString().padLeft(2,"0")}/${bttemp[i].bt_date.year}",
                    "bt_time": "${bttemp[i].bt_time.hour.toString().padLeft(2,"0")}:${bttemp[i].bt_time.minute.toString().padLeft(2,"0")}",
                    "indication": bttemp[i].indication.toString(),
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
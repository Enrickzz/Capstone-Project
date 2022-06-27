import 'dart:convert';
import 'dart:io';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/goal_tab/water/add_water_intake.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class water_intake_support_view extends StatefulWidget {
  final String userUID;
  water_intake_support_view({Key key, this.userUID}): super(key: key);
  @override
  _waterIntakeSupportState createState() => _waterIntakeSupportState();
}

class _waterIntakeSupportState extends State<water_intake_support_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<WaterIntake> waterintake_list = [];
  Physical_Parameters pp = new Physical_Parameters();
  List<File> _image = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");


  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];
  /// body temp status (normal, low, high)
  List<String> status = [];


  @override
  void initState() {
    super.initState();
    waterintake_list.clear();
    getWaterIntake();
    // getBMIList();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(waterintake_list.length, (int index) => false);

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
        title: const Text('My Water Intake', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              _showMyDialogDelete();

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
                      child: add_water_intake(),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      waterintake_list = value;
                      _selected = List<bool>.generate(waterintake_list.length, (int index) => false);

                    }
                    print("SYMP LENGTH AFTER SETSTATE  =="  + waterintake_list.length.toString() );
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
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  void getWaterIntake() {
    final User user = auth.currentUser;
    String userUID = widget.userUID;
    final readWaterIntake = databaseReference.child('users/' + userUID + '/goal/water_intake/');
    readWaterIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        waterintake_list.add(WaterIntake.fromJson(jsonString));
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
              waterintake_list.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
            } else {
              waterintake_list.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Water Intake')),

    ];

  }

  List<DataRow> _createRows() {
    return waterintake_list
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.dateCreated.toString()))),
          DataCell(Text(getTimeFormatted(bp.timeCreated.toString()))),
          DataCell(Text(bp.water_intake.toString() +'mL', style: TextStyle(),)),
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
                final User user = auth.currentUser;
                final userUID = widget.userUID;
                int initialLength = waterintake_list.length;
                List<int> deleteList = [];
                for(int i = 0; i < waterintake_list.length; i++){
                  if(_selected[i]){
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a,b) => b.compareTo(a));
                for(int i = 0; i < deleteList.length; i++){
                  waterintake_list.removeAt(deleteList[i]);
                }
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/goal/water_intake/' + i.toString());
                  bpRef.remove();
                }
                for(int i = 0; i < waterintake_list.length; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/goal/water_intake/' + (i+1).toString());
                  bpRef.set({
                    "water_intake": waterintake_list[i].water_intake.toString(),
                    "dateCreated": "${waterintake_list[i].dateCreated.month.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.day.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.year}",
                    "timeCreated": "${waterintake_list[i].timeCreated.hour.toString().padLeft(2,"0")}:${waterintake_list[i].timeCreated.minute.toString().padLeft(2,"0")}"
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
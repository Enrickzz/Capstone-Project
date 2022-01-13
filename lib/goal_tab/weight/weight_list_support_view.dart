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
import 'package:my_app/goal_tab/water/add_water_intake.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../../fitness_app_theme.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class weight_list_support_view extends StatefulWidget {
  final List<Body_Temperature> btlist;
  String userUID;
  weight_list_support_view({Key key, this.btlist, this.userUID}): super(key: key);
  @override
  _weightDoctorstate createState() => _weightDoctorstate();
}

class _weightDoctorstate extends State<weight_list_support_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Weight> weights = [];
  Physical_Parameters pp = new Physical_Parameters();
  List<double> bmi = [];
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
    weights.clear();
    getWeight();
    // getBMIList();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(weights.length, (int index) => false);

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
        title: const Text("Patient's Weight", style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,

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
  void getWeight() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeight = databaseReference.child('users/' + uid + '/goal/weight/');
    readWeight.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weights.add(Weight.fromJson(jsonString));
      });
    });
  }
  // void getBodyTemp() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readBT = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
  //   readBT.once().then((DataSnapshot snapshot){
  //     List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
  //     temp.forEach((jsonString) {
  //       bttemp.add(Body_Temperature.fromJson(jsonString));
  //     });
  //   });
  // }

  int getAge (DateTime birthday) {
    DateTime today = new DateTime.now();
    String days1 = "";
    String month1 = "";
    String year1 = "";
    int d = int.parse(DateFormat("dd").format(birthday));
    int m = int.parse(DateFormat("MM").format(birthday));
    int y = int.parse(DateFormat("yyyy").format(birthday));
    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    int age = 0;
    age = y1 - y;
    print(age);

    // dec < jan
    if(m1 < m){
      print("month --");
      age--;
    }
    else if (m1 == m){
      if(d1 < d){
        print("day --");
        age--;
      }
    }
    return age;
  }

  Color getMyColor(double bmi) {
    if(bmi < 18.5){
      return Colors.blue;
      //underweight
    }
    else if(bmi >= 18.5 && bmi <= 24.9){
      return Colors.green;
      //normal

    }
    else if(bmi >= 25 && bmi <= 29.9){
      return Colors.deepOrange;
      //overweight

    }
    else
      return Colors.red;
    //obese

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
              weights.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
            } else {
              weights.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Weight')),
      DataColumn(label: InkWell(onTap: (){
        showLegend();

      },child: Text('BMI'))),


    ];

  }

  List<DataRow> _createRows() {
    return weights
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.dateCreated.toString()))),
          DataCell(Text(getTimeFormatted(bp.timeCreated.toString()))),
          DataCell(Text(bp.weight.toStringAsFixed(1) +'kg', style: TextStyle(),)), //weight
          DataCell(Text(bp.bmi.toStringAsFixed(1), style: TextStyle(color: getMyColor(bp.bmi)))), //bmi
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

  Future<void> showLegend() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('BMi Legend'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 20,),
                    Text('Underweight')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20,),
                    Text('Normal')
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 20,),
                    Text('Overweight')
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text('Obese')
                  ],
                )


              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: Text('Got it'),
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
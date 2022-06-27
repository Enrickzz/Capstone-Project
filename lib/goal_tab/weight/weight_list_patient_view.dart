import 'dart:convert';
import 'dart:io';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/goal_tab/weight/add_weight_record.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class weight_list_patient_view extends StatefulWidget {
  weight_list_patient_view({Key key}) : super(key: key);
  @override
  _weightPatienttate createState() => _weightPatienttate();
}

class _weightPatienttate extends State<weight_list_patient_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(
          databaseURL:
              "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Weight> weights = [];
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
    weights.clear();
    getWeight();
    // getBMIList();
    Future.delayed(const Duration(milliseconds: 1500), () {
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
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('My Weight', style: TextStyle(color: Colors.black)),
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
          //
          // GestureDetector(
          //   onTap: () {
          //     _showMyDialogDelete();
          //
          //   },
          //   child: Icon(
          //     Icons.perm_device_information_sharp ,
          //   ),
          // ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: add_weight_record(),
                      ),
                    ),
                  ).then((value) {
                    print("AFTER ADD");
                    print("VALUE\n" + value.toString());
                    var value1 = value;
                    BoxedReturns thisReturned = value;
                    weights = thisReturned.WE_result; // update list
                    if (thisReturned.dialog.message == null ||
                        thisReturned.dialog.title == null ||
                        thisReturned.dialog.redirect == null) {
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        setState(() {
                          _selected = List<bool>.generate(
                              weights.length, (int index) => false);
                        });
                      });
                    } else {
                      ShowDialogRecomm(thisReturned.dialog.message,
                              thisReturned.dialog.title)
                          .then((value) {
                        print("AFTER DIALOG");
                        if (value1 != null) {
                          print("VALUE NOT NULL");
                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            setState(() {
                              _selected = List<bool>.generate(
                                  weights.length, (int index) => false);
                            });
                          });
                        }
                      });
                    }
                  });

                  // ((value) => setState((){
                  //   if(value != null){
                  //     weights = value;
                  //     _selected = List<bool>.generate(weights.length, (int index) => false);

                  //   }
                  //   print("SYMP LENGTH AFTER SETSTATE  =="  + weights.length.toString() );
                  // }));
                },
                child: Icon(
                  Icons.add,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: _createDataTable()),
        ),
      ),
    );
  }

  String getDateFormatted(String date) {
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }

  String getTimeFormatted(String date) {
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }

  void getWeight() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeight =
        databaseReference.child('users/' + uid + '/goal/weight/');
    readWeight.once().then((DataSnapshot snapshot) {
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weights.add(Weight.fromJson(jsonString));
      });
      weights = weights.reversed.toList();
    });
  }

  int getAge(DateTime birthday) {
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
    if (m1 < m) {
      print("month --");
      age--;
    } else if (m1 == m) {
      if (d1 < d) {
        print("day --");
        age--;
      }
    }
    return age;
  }

  Color getMyColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
      //underweight
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return Colors.green;
      //normal

    } else if (bmi >= 25 && bmi <= 29.9) {
      return Colors.deepOrange;
      //overweight

    } else
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
      headingTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.lightBlue),
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
      DataColumn(
          label: InkWell(
              onTap: () {
                showLegend();
              },
              child: Text('BMI'))),
    ];
  }

  List<DataRow> _createRows() {
    return weights
        .mapIndexed((index, bp) => DataRow(
                cells: [
                  DataCell(Text(getDateFormatted(bp.dateCreated.toString()))),
                  DataCell(Text(getTimeFormatted(bp.timeCreated.toString()))),
                  DataCell(Text(
                    bp.weight.toStringAsFixed(1) + 'kg',
                    style: TextStyle(),
                  )), //weight
                  DataCell(Text(bp.bmi.toStringAsFixed(1),
                      style: TextStyle(color: getMyColor(bp.bmi)))), //bmi
                ],
                selected: _selected[index],
                onSelectChanged: (bool selected) {
                  setState(() {
                    _selected[index] = selected;
                  });
                }))
        .toList();
  }

  Future<void> ShowDialogRecomm(String desc, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('$desc'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                int initialLength = weights.length;
                List<int> deleteList = [];
                for (int i = 0; i < weights.length; i++) {
                  if (_selected[i]) {
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a, b) => b.compareTo(a));
                for (int i = 0; i < deleteList.length; i++) {
                  weights.removeAt(deleteList[i]);
                }
                for (int i = 1; i <= initialLength; i++) {
                  final bpRef = databaseReference
                      .child('users/' + uid + '/goal/weight/' + i.toString());
                  bpRef.remove();
                }
                for (int i = 0; i < weights.length; i++) {
                  final bpRef = databaseReference.child(
                      'users/' + uid + '/goal/weight/' + (i + 1).toString());
                  bpRef.set({
                    "weight": weights[i].weight.toString(),
                    "bmi": weights[i].bmi.toString(),
                    "dateCreated":
                        "${weights[i].dateCreated.month.toString().padLeft(2, "0")}/${weights[i].dateCreated.day.toString().padLeft(2, "0")}/${weights[i].dateCreated.year}",
                    "timeCreated":
                        "${weights[i].timeCreated.hour.toString().padLeft(2, "0")}:${weights[i].timeCreated.minute.toString().padLeft(2, "0")}"
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
                    SizedBox(
                      width: 20,
                    ),
                    Text('Underweight')
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Normal')
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Overweight')
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 20,
                    ),
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

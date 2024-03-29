import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
class sleep_support_view extends StatefulWidget {
  final List<Body_Temperature> btlist;
  sleep_support_view({Key key, this.btlist}): super(key: key);
  @override
  _sleepState createState() => _sleepState();
}

class _sleepState extends State<sleep_support_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Body_Temperature> bttemp = [];
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
    // bttemp.clear();
    // _selected.clear();
    // getBodyTemp();
    // Future.delayed(const Duration(milliseconds: 1500), (){
    //   setState(() {
    //     _selected = List<bool>.generate(bttemp.length, (int index) => false);
    //
    //     print("setstate");
    //   });
    // });
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
        title: const Text("Patient's Sleep Record", style: TextStyle(
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
              bttemp.sort((a, b) => b.bt_date.compareTo(a.bt_date));
            } else {
              bttemp.sort((a, b) => a.bt_date.compareTo(b.bt_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Sleep Duration')),
      DataColumn(label: Text('REM Duration')),
      DataColumn(label: Text('Deep Sleep Duration')),
      DataColumn(label: Text('Light Sleep Duration')),
      DataColumn(label: Text('Sleep Score')),



    ];

  }

  List<DataRow> _createRows() {
    return bttemp
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.bt_date.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(getTimeFormatted(bp.bt_time.toString()))),
          DataCell(Text(bp.temperature.toStringAsFixed(1) +'°C', style: TextStyle(),)),
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
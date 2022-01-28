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
import 'package:my_app/goal_tab/water/change_water_intake_goal.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:my_app/ui_view/Sleep_StackedBarChart.dart';
import '../../../fitness_app_theme.dart';
import 'package:http/http.dart' as http;


//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class sleep_patient_view extends StatefulWidget {
  final List<Body_Temperature> btlist;
  final String fitbitToken;
  sleep_patient_view({Key key, this.btlist, this.fitbitToken}): super(key: key);
  @override
  _sleep_patient_viewState createState() => _sleep_patient_viewState();
}

class _sleep_patient_viewState extends State<sleep_patient_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // List<Body_Temperature> sleep_list = [];
  List<File> _image = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  List<Oxygen> sleep_list = [];
  List<OrdinalSales> rem=[];
  List<OrdinalSales> light=[];
  List<OrdinalSales> deep=[];
  List<OrdinalSales> wake=[];



  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];
  /// body temp status (normal, low, high)
  List<String> status = [];
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState() {
    initNotif();
    super.initState();
    // bttemp.clear();
    // _selected.clear();
    // getBodyTemp();
    getSleep();
    Future.delayed(const Duration(milliseconds: 5000), (){
      // setState(() {
      //   _selected = List<bool>.generate(sleep_list.length, (int index) => false);
      //   print("setstate");
      // });
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
        title: const Text('My Sleep Record', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [



        
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
  void addtoRecommendation(String message, String title, String priority, String redirect){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }
    });
  }
  void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
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
              sleep_list.sort((a, b) => b.dateOfSleep.compareTo(a.dateOfSleep));
            } else {
              sleep_list.sort((a, b) => a.dateOfSleep.compareTo(b.dateOfSleep));
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
    return sleep_list
        .mapIndexed((index, bp) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(bp.dateOfSleep.toString()))),
          DataCell(Text(milisecondToTime(bp.duration).toString() + " hr")),
          DataCell(Text(secondToTime(rem[index].sales).toString()  + " hr")),
          DataCell(Text(secondToTime(deep[index].sales).toString() + " hr")),
          DataCell(Text(secondToTime(light[index].sales).toString()+ " hr")),
          DataCell(Text((bp.efficiency - 10).toString(), style: TextStyle(),)),
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
  Future<void> showListRefresh() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('List Refresh'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Getting your latest sleep log from your Fitbit account..",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),


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
  void getSleep() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer " + widget.fitbitToken
        });
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleep_list = sleep;
    if(sleep_list[0].duration/3600000 < 6){
      // print("less than 6 hrs");
      // print(sleep_list[0].duration/3600000);
      List<RecomAndNotif> notifsList=[];
      final User user = auth.currentUser;
      final uid = user.uid;
      final readBP = databaseReference.child('users/' + uid + '/recommendations/');
      bool exists = false;
      await readBP.once().then((DataSnapshot snapshot){
        // print(snapshot.value);
        notifsList.clear();
        List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        if(temp != null){
          temp.forEach((jsonString) {
            RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
            // print("DATES");
            // print(a.rec_date +"\n" + date);
            if(a.rec_date == date){
              if(a.message == "We recommend that you should sleep 7-9 hours a night as consistent "
                  "lack of sleep could be detrimental to your health. Poor sleep triggers chronic inflammation, "
                  "which contributes to plaque formation and hardening of your arteries."){
                exists = true;
                // print("IT ALREADY EXISTS TODAY");
              }
            }
            notifsList.add(RecomAndNotif.fromJson(jsonString));
          });
        }
        if(exists == false){
          // print("FALSE ADD TO RECOMM");
          addtoRecommendation("We recommend that you should sleep 7-9 hours a night as consistent "
              "lack of sleep could be detrimental to your health. Poor sleep triggers chronic inflammation, "
              "which contributes to plaque formation and hardening of your arteries.",
              "You lack Sleep!",
              "1",
              "None");
        }
      });
    }
    String a;
    for(var i = 0 ; i < sleep_list.length ; i ++){
      rem.add(new OrdinalSales("", 0));
      deep.add(new OrdinalSales("", 0));
      light.add(new OrdinalSales("", 0));
      wake.add(new OrdinalSales("", 0));
      // print("i is ");
      // print(i);
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        a = sleep[i].levels.data[j].dateTime;
        a = a.substring(0, a.indexOf("T"));
        rem[i].date = a;
        deep[i].date = a;
        light[i].date = a;
        wake[i].date = a;
        if(sleep[i].levels.data[j].level == "rem" || sleep[i].levels.data[j].level == "restless"){
          rem[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "deep" || sleep[i].levels.data[j].level  == "asleep"){
          deep[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "light" || sleep[i].levels.data[j].level  == "restless"){
          light[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "wake" || sleep[i].levels.data[j].level  == "awake"){
          wake[i].sales += sleep[i].levels.data[j].seconds;
        }
      }
    }
    // print("LIGHT LENGTH");
    // print(light.length);
    // // print(wake.length);
    // print(deep.length);
    // print(rem.length);
    // print(sleep_list.length);
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
    setState(() {
      _selected = List<bool>.generate(sleep_list.length, (int index) => false);
      // print("setstate");
    });
  }
  String milisecondToTime(int duration){
    var hours = (duration / 3600000).floor();
    var minutes = (duration / 60000).remainder(60).toStringAsFixed(0).padLeft(2,"0");
      return "$hours:$minutes";
  }
  String secondToTime(double duration){
    var hours = (duration / 3600).floor();
    var minutes = (duration / 60).remainder(60).toStringAsFixed(0).padLeft(2,"0");
    return "$hours:$minutes";
  }
}
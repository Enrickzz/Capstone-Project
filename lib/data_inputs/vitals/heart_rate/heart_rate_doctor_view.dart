import 'dart:convert';

import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class heart_rate_doctor_view extends StatefulWidget {
  final List<Heart_Rate> hrlist;
  final String userUID;
  heart_rate_doctor_view({Key key, this.hrlist, this.userUID}): super(key: key);
  @override
  _heart_rate_doctorState createState() => _heart_rate_doctorState();
}

class _heart_rate_doctorState extends State<heart_rate_doctor_view> {
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Heart_Rate> hrtemp = [];

  //for table
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    hrtemp.clear();
    _selected.clear();
    getHeartRate();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final readHeartRate = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list');
    // String tempBmi = ""; // int
    // String tempisResting = ""; //bool
    // String tempHRDate = "";
    // String tempHRTime = "";
    // DateFormat format = new DateFormat("MM/dd/yyyy");
    // DateFormat timeformat = new DateFormat("hh:mm");
    //
    // readHeartRate.once().then((DataSnapshot datasnapshot) {

    //   String temp1 = datasnapshot.value.toString();
    //   List<String> temp = temp1.split(',');
    //   Heart_Rate heartRate;
    //   for(var i = 0; i < temp.length; i++) {
    //     String full = temp[i].replaceAll("{", "")
    //         .replaceAll("}", "")
    //         .replaceAll("[", "")
    //         .replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //       switch(i%4) {
    //         case 0:
    //           {
    //             tempHRTime = splitFull.last;
    //           }
    //           break;
    //         case 1:
    //           {
    //             tempBmi = splitFull.last;
    //           }
    //           break;
    //         case 2:
    //           {
    //             tempisResting = splitFull.last;
    //           }
    //           break;
    //         case 3:
    //           {
    //             tempHRDate = splitFull.last;
    //             heartRate = new Heart_Rate(bpm: int.parse(tempBmi),
    //                 hr_status: tempisResting,
    //                 hr_date: format.parse(tempHRDate),
    //                 hr_time: timeformat.parse(tempHRTime));
    //             hrtemp.add(heartRate);
    //           }
    //           break;
    //       }
    //   }
    //   for(var i=0;i<hrtemp.length/2;i++){
    //     var temp = hrtemp[i];
    //     hrtemp[i] = hrtemp[hrtemp.length-1-i];
    //     hrtemp[hrtemp.length-1-i] = temp;
    //   }
    // });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(hrtemp.length, (int index) => false);
        print(hrtemp);
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
        title: const Text('Heart Rate', style: TextStyle(
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
      // body: ListView.builder(
      //   itemCount: hrtemp.length,
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
      //                             '' + getDateFormatted(hrtemp[index].getDate.toString())+getTimeFormatted(hrtemp[index].getTime.toString())+" "
      //                                 +"\nHeart rate: "+ hrtemp[index].getBPM.toString() + " BPM"
      //                                 +"\nResting: "+ hrtemp[index].getisResting.toString() + "  " ,
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
      // )

    );
  }

  bool parseBool(String temp) {
    if (temp.toLowerCase() == 'false') {
      return false;
    } else if (temp.toLowerCase() == 'true') {
      return true;
    }
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
    if(indication == 'Active'){
      return Colors.red;
    }
    else
      return Colors.blue;

  }

  Color getMyColorHeartRate(int indication) {
    if(indication <= 40){
      return Colors.orange;
    }
    else if(indication >= 41 && indication <= 100){
      return Colors.green;

    }
    else{
      return Colors.red;
    }
    return Colors.blue;

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
              hrtemp.sort((a, b) => b.hr_date.compareTo(a.hr_date));
            } else {
              hrtemp.sort((a, b) => a.hr_date.compareTo(b.hr_date));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(label: Text('Time')),
      DataColumn(label: InkWell(onTap: (){
        showLegend();

      },child: Text('Heart Rate'))),
      DataColumn(label: Text('Status'))

    ];

  }

  List<DataRow> _createRows() {
    return hrtemp
        .mapIndexed((index, hr) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(hr.hr_date.toString()))),
          DataCell(Text(getTimeFormatted(hr.hr_time.toString()))),
          DataCell(Text(hr.bpm.toString(), style: TextStyle(color: getMyColorHeartRate(hr.bpm)),)),
          DataCell(Text(hr.hr_status, style: TextStyle(color: getMyColor(hr.hr_status)),))
        ],
        selected: _selected[index],
        onSelectChanged: (bool selected) {
          setState(() {
            _selected[index] = selected;
          });
        }))
        .toList();
  }


  void getHeartRate() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readHR = databaseReference.child('users/' + userUID + '/vitals/health_records/heartrate_list/');
    readHR.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        hrtemp.add(Heart_Rate.fromJson(jsonString));
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
                int initialLength = hrtemp.length;
                List<int> deleteList = [];
                for(int i = 0; i < hrtemp.length; i++){
                  if(_selected[i]){
                    deleteList.add(i);
                  }
                }
                deleteList.sort((a,b) => b.compareTo(a));
                for(int i = 0; i < deleteList.length; i++){
                  hrtemp.removeAt(deleteList[i]);
                }
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/heartrate_list/' + i.toString());
                  bpRef.remove();
                }
                for(int i = 0; i < hrtemp.length; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/heartrate_list/' + (i+1).toString());
                  bpRef.set({
                    "HR_bpm": hrtemp[i].bpm.toString(),
                    "hr_status": hrtemp[i].hr_status.toString(),
                    "hr_date": "${hrtemp[i].hr_date.month.toString().padLeft(2,"0")}/${hrtemp[i].hr_date.day.toString().padLeft(2,"0")}/${hrtemp[i].hr_date.year}",
                    "hr_time": "${hrtemp[i].hr_time.hour.toString().padLeft(2,"0")}:${hrtemp[i].hr_time.minute.toString().padLeft(2,"0")}"
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
          title: Text('Heart Rate'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                SizedBox(height: 5,),

                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 20,),
                    Text('Low')
                  ],
                ),
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


                Row(
                  children: [
                    Icon(
                      Icons.panorama_wide_angle_select_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 20,),
                    Text('High')
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
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../../fitness_app_theme.dart';
import 'add_blood_pressure.dart';
import 'add_o2_saturation.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class o2_saturation extends StatefulWidget {
  final List<Oxygen_Saturation> oxygenlist;
  o2_saturation({Key key, this.oxygenlist}): super(key: key);
  @override
  _o2_saturationState createState() => _o2_saturationState();
}

class _o2_saturationState extends State<o2_saturation> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Oxygen_Saturation> oxygentemp = [];

  //for table
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readOxygen = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list');
    String tempOxygen = "";
    String tempOxygenDate = "";
    String tempOxygenTime = "";
    DateFormat format = new DateFormat("MM/dd/yyyy");
    DateFormat timeformat = new DateFormat("hh:mm");
    readOxygen.once().then((DataSnapshot datasnapshot) {
      oxygentemp.clear();
      _selected.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Oxygen_Saturation oxygen;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        switch(i%3){
          case 0: {
            print("i value" + i.toString() + splitFull.last);
            tempOxygen = splitFull.last;
          }
          break;
          case 1: {
            print("i value" + i.toString() + splitFull.last);
            tempOxygenDate = splitFull.last;
          }
          break;
          case 2: {
            print("i value" + i.toString() + splitFull.last);
            tempOxygenTime = splitFull.last;
            oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen), os_date: format.parse(tempOxygenDate), os_time: timeformat.parse(tempOxygenTime));
            oxygentemp.add(oxygen);
          }
          break;
        }

      }
      for(var i=0;i<oxygentemp.length/2;i++){
        var temp = oxygentemp[i];
        oxygentemp[i] = oxygentemp[oxygentemp.length-1-i];
        oxygentemp[oxygentemp.length-1-i] = temp;
      }
    });
    oxygentemp = widget.oxygenlist;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _selected = List<bool>.generate(oxygentemp.length, (int index) => false);
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
        title: const Text('Oxygen Saturation', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: add_o2_saturation(o2list: oxygentemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      oxygentemp = value;
                      _selected = List<bool>.generate(oxygentemp.length, (int index) => false);

                    }
                    print("OXY LENGTH AFTER SETSTATE  =="  + oxygentemp.length.toString() );
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
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _createDataTable()

          ),





        ),
        // body: ListView.builder(
        //   itemCount: oxygentemp.length,
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
        //                             '' + getDateFormatted(oxygentemp[index].getDate.toString())+getTimeFormatted(oxygentemp[index].getTime.toString())+" \n" + "My O2 level: " +oxygentemp[index].getOxygenSaturation.toString() +" %SpO2",
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
  Color getMyColor(int indication) {
    if(indication < 85){
      return Colors.red;
    }
    else if(indication <= 94 && indication >= 85){
      return Colors.orange;

    }
    else{
      return Colors.green;
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
              oxygentemp.sort((a, b) => b.getDate.compareTo(a.getDate));
            } else {
              oxygentemp.sort((a, b) => a.getDate.compareTo(b.getDate));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),



      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Oxygen Level')),

    ];

  }

  List<DataRow> _createRows() {
    return oxygentemp
        .mapIndexed((index, os) => DataRow(
        cells: [
          DataCell(Text(getDateFormatted(os.getDate.toString()))),
          DataCell(Text(getTimeFormatted(os.getTime.toString()))),
          DataCell(Text("          "+os.getOxygenSaturation.toString(), style: TextStyle(color: getMyColor(os.getOxygenSaturation)),))

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
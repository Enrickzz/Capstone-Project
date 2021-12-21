import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/checkbox_state.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class medicalHistory extends StatefulWidget {
  @override
  _MedicalHistoryState createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<medicalHistory> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';

  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;
  var dateValue = TextEditingController();

  bool isSwitched = false;
  bool isSwitchedLifestyle = false;

  String goal = '';
  DateTime prescriptionDate;
  var startDate = TextEditingController();
  String startdate = "";
  List <bool> isSelected = [true, false];
  String unitstatus = '';
  String unitStatus = "kg";
  String valueLifestyle;

  List<String> listLifestyle = <String>[
    'Sedentary',
    'Light Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active'
  ];

  // for the list of all CVD
  List<String> cvdChecboxStatus = [];
  final cvd_list ={
    CheckBoxState(title: 'Arrhythmia'),
    CheckBoxState(title: 'Bradycardia'),
    CheckBoxState(title: 'Cardiomyopathy'),
    CheckBoxState(title: 'Congestive Heart Failure'),
    CheckBoxState(title: 'Coronary Heart Disease'),
    CheckBoxState(title: 'Heart Valve Disease (Congenital Heart Disease)'),
    CheckBoxState(title: 'Myocardial Infarction'),
    CheckBoxState(title: 'Rheumatic Heart Disease')

  };






  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.close),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 90,
                      alignment: Alignment.center,
                      child: Text("Medical History",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text("What kind of Cardiovascular disease do you have? (choose all that applies)",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                    SizedBox(height: 8.0),
                    ...cvd_list.map(buildSingleCheckbox).toList(),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text(' ')),
      DataColumn(label: Text('Exercise Load')),
      DataColumn(label: Text('Exercise/Sports/Work'))
    ];
  }
  List<DataRow> _createRows() {
    return [
      DataRow(cells: [
        DataCell(Text('Sedentary')),
        DataCell(Text('None/Little')),
        DataCell(Text('None'))
      ]),
      DataRow(cells: [
        DataCell(Text('Lightly Active')),
        DataCell(Text('Light')),
        DataCell(Text('1-3 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Moderately Active')),
        DataCell(Text('Moderate')),
        DataCell(Text('3-5 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Very Active')),
        DataCell(Text('Hard')),
        DataCell(Text('6-7 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Extremely Active')),
        DataCell(Text('Very Hard')),
        DataCell(Text('Physical Labor'))
      ])

    ];
  }
  Widget buildSingleCheckbox(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: CheckboxListTile(
      activeColor: Colors.green,
      value: checkbox.value,
      title: Text(
          checkbox.title
      ),

      onChanged: (value) => setState(() => {
        checkbox.value = value,
        if(checkbox.value){
          cvdChecboxStatus.add(checkbox.title),
        }
        else{
          for(int i = 0; i < cvdChecboxStatus.length; i++){
            if(cvdChecboxStatus[i] == checkbox.title){
              cvdChecboxStatus.removeAt(i)
            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );
}

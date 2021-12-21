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

  final cvdOthers ={
    CheckBoxState(title: 'Others'),

  };

  bool cvd_others_check = false;
  static List<String> otherCVDList = [null];







  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    ...cvd_list.map(buildSingleCheckboxCVD).toList(),
                    ...cvdOthers.map(buildSingleCheckboxCVDOthers).toList(),

                    SizedBox(
                      height: 8,
                    ),

                   Visibility(
                       visible: cvd_others_check,
                       child: Text('Other Cardiovascular Diseases', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                       ),
                   ),
                    ..._getOtherCVD(),




                  ],
                ),
              ],
            ),
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
  Widget buildSingleCheckboxCVD(CheckBoxState checkbox) =>  Visibility(
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
  Widget buildSingleCheckboxCVDOthers(CheckBoxState checkbox) =>  Visibility(
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
          cvd_others_check = true
        }
        else{
          for(int i = 0; i < cvdChecboxStatus.length; i++){
            if(cvdChecboxStatus[i] == checkbox.title){
              cvdChecboxStatus.removeAt(i),
              cvd_others_check = false


            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );
  List<Widget> _getOtherCVD(){
    List<Widget> foodsTextFields = [];
    for(int i=0; i<otherCVDList.length; i++){
      foodsTextFields.add(
          Visibility(
            visible: cvd_others_check,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: FoodTextFields(i)),
                  SizedBox(width: 16,),
                  // we need add button at last friends row
                  _addRemoveButtonFood(i == otherCVDList.length-1, i),
                ],
              ),
            ),
          )
      );
    }
    return foodsTextFields;
  }

  Widget _addRemoveButtonFood(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          otherCVDList.insert(0, null);
        }
        else otherCVDList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }
}

class FoodTextFields extends StatefulWidget {
  final int index;
  FoodTextFields(this.index);
  @override
  _FoodTextFieldsState createState() => _FoodTextFieldsState();
}

class _FoodTextFieldsState extends State<FoodTextFields> {
  TextEditingController _nameControllerFoods;

  @override
  void initState() {
    super.initState();
    _nameControllerFoods = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerFoods.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerFoods.text = _MedicalHistoryState.otherCVDList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerFoods,
      onChanged: (v) => _MedicalHistoryState.otherCVDList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your Food Allergies'
      ),
      validator: (f){
        if(f.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }


}



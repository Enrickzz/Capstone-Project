import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/profile/patient/profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/checkbox_state.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_medical_history extends StatefulWidget {
  @override
  _MedicalHistoryState createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<edit_medical_history> {
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
// other CVD conditions
  final cvdOthers ={
    CheckBoxState(title: 'Others'),

  };

  bool cvd_others_check = false;
  static List<String> otherCVDList = [null];
  List<String> cvdOtherChecboxStatus = [];

  // for the list of other medical conditions
  List<String> additionalConditionChecboxStatus = [];
  final additional_list ={
    CheckBoxState(title: 'Chronic Obstructive Pulmonary Disease'),
    CheckBoxState(title: 'Chronic Kidney Disease'),
    CheckBoxState(title: 'Diabetes'),
    CheckBoxState(title: 'High Cholesterol'),
    CheckBoxState(title: 'Hypertension'),
    CheckBoxState(title: 'Mental Health Issues'),
    CheckBoxState(title: 'Stroke'),

  };

  final additionalConditionOthers ={
    CheckBoxState(title: 'Others'),

  };
  List<String> additionalConditionOthersChecboxStatus= [];

  bool additional_condition_others_check = false;
  static List<String>additionalConditionList = [null];

  //for family history
  List<String> familyConditionCheckboxStatus = [];
  final family_condition_list ={
    CheckBoxState(title: 'Chronic Obstructive Pulmonary Disease'),
    CheckBoxState(title: 'Chronic Kidney Disease'),
    CheckBoxState(title: 'Diabetes'),
    CheckBoxState(title: 'High Cholesterol'),
    CheckBoxState(title: 'Hypertension'),
    CheckBoxState(title: 'Mental Health Issues'),
    CheckBoxState(title: 'Stroke'),

  };

  List<String> additionalConditionFamilyChecboxStatus= [];
  bool family_condition_others_check = false;

  final faimlyConditionOthers ={
    CheckBoxState(title: 'Others'),

  };
  List<String> familyConditionOthersChecboxStatus= [];
  static List<String> familyConditionList = [null];








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
                      height: 200,
                      alignment: Alignment.center,
                      child:
                      Text("Edit Medical History",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                          )),
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
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text("Do you have any other medical conditions? (choose all that applies)",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...additional_list.map(buildSingleCheckboxAdditionalConditions).toList(),
                    ...additionalConditionOthers.map(buildSingleCheckboxAdditionalConditionsOthers).toList(),

                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: additional_condition_others_check,
                      child: Text('Other Medical Conditions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    ..._getAdditionalConditions(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text("Any family members with medical conditions? (choose all that applies)",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...family_condition_list.map(buildSingleCheckboxFamilyConditions).toList(),
                    ...faimlyConditionOthers.map(buildSingleCheckboxFamilyConditionsOthers).toList(),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: family_condition_others_check,
                      child: Text('Family History Medical Conditions',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    ..._getFamilyConditions()


                  ],

                ),
                Container(
                  child: ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text('Edit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      try{
                        getOtherDisease();
                        final User user = auth.currentUser;
                        final uid = user.uid;
                        final personalInfoRef = databaseReference.child('users/' + uid + '/vitals/additional_info/');
                        personalInfoRef.update({"disease": cvdChecboxStatus, "other_disease": additionalConditionChecboxStatus, "family_disease": familyConditionCheckboxStatus});
                        print("Edited Medical History Successfully! " + uid);
                        Navigator.pop(context);
                      } catch(e) {
                        print("you got an error! $e");
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => index3(animationController: animationController)),
                      // );
                    },
                  ),
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
          cvdOtherChecboxStatus.add(checkbox.title),
          cvd_others_check = true
        }
        else{
          for(int i = 0; i < cvdOtherChecboxStatus.length; i++){
            if(cvdOtherChecboxStatus[i] == checkbox.title){
              cvdOtherChecboxStatus.removeAt(i),
              cvd_others_check = false


            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );

  Widget buildSingleCheckboxAdditionalConditions(CheckBoxState checkbox) =>  Visibility(
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
          additionalConditionChecboxStatus.add(checkbox.title),
        }
        else{
          for(int i = 0; i < additionalConditionChecboxStatus.length; i++){
            if(additionalConditionChecboxStatus[i] == checkbox.title){
              additionalConditionChecboxStatus.removeAt(i)
            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );

  Widget buildSingleCheckboxAdditionalConditionsOthers(CheckBoxState checkbox) =>  Visibility(
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
          additionalConditionOthersChecboxStatus.add(checkbox.title),
          additional_condition_others_check = true
        }
        else{
          for(int i = 0; i < additionalConditionOthersChecboxStatus.length; i++){
            if(additionalConditionOthersChecboxStatus[i] == checkbox.title){
              additionalConditionOthersChecboxStatus.removeAt(i),
              additional_condition_others_check = false


            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );
  Widget buildSingleCheckboxFamilyConditions(CheckBoxState checkbox) =>  Visibility(
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
          familyConditionCheckboxStatus.add(checkbox.title),
        }
        else{
          for(int i = 0; i < familyConditionCheckboxStatus.length; i++){
            if(familyConditionCheckboxStatus[i] == checkbox.title){
              familyConditionCheckboxStatus.removeAt(i)
            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );

  Widget buildSingleCheckboxFamilyConditionsOthers(CheckBoxState checkbox) =>  Visibility(
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
          additionalConditionFamilyChecboxStatus.add(checkbox.title),
          family_condition_others_check = true
        }
        else{
          for(int i = 0; i < additionalConditionFamilyChecboxStatus.length; i++){
            if(additionalConditionFamilyChecboxStatus[i] == checkbox.title){
              additionalConditionFamilyChecboxStatus.removeAt(i),
              family_condition_others_check = false


            },
          },
        },
      }),
      controlAffinity: ListTileControlAffinity.leading,
    ),
  );

  List<Widget> _getOtherCVD(){
    List<Widget> otherCVDsTextFields = [];
    for(int i=0; i<otherCVDList.length; i++){
      otherCVDsTextFields.add(
          Visibility(
            visible: cvd_others_check,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: OtherCVDTextFields(i)),
                  SizedBox(width: 16,),
                  // we need add button at last friends row
                  _addRemoveButtonOtherCVD(i == otherCVDList.length-1, i),
                ],
              ),
            ),
          )
      );
    }
    return otherCVDsTextFields;
  }

  Widget _addRemoveButtonOtherCVD(bool add, int index){
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

  // other conditions
  List<Widget> _getAdditionalConditions(){
    List<Widget> additionalConditionsTextFields = [];
    for(int i=0; i<additionalConditionList.length; i++){
      additionalConditionsTextFields.add(
          Visibility(
            visible: additional_condition_others_check,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: AdditionalConditionsTextFields(i)),
                  SizedBox(width: 16,),
                  // we need add button at last friends row
                  _addRemoveButtonAdditionalConditions(i == additionalConditionList.length-1, i),
                ],
              ),
            ),
          )
      );
    }
    return additionalConditionsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonAdditionalConditions(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          additionalConditionList.insert(0, null);
        }
        else additionalConditionList.removeAt(index);
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
  // get firends text-fields
  List<Widget> _getFamilyConditions(){
    List<Widget> familyConditionsTextFields = [];
    for(int i=0; i<familyConditionList.length; i++){
      familyConditionsTextFields.add(
          Visibility(
            visible: family_condition_others_check,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: FamilyConditionsTextFields(i)),
                  SizedBox(width: 16,),
                  // we need add button at last friends row
                  _addRemoveButtonFamilyConditions(i == familyConditionList.length-1, i),
                ],
              ),
            ),
          )
      );
    }
    return familyConditionsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonFamilyConditions(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          familyConditionList.insert(0, null);
        }
        else familyConditionList.removeAt(index);
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
  void getOtherDisease(){
    if(cvdChecboxStatus != null){
      if(cvd_others_check){
        for(int i = 0; i < otherCVDList.length; i++){
          cvdChecboxStatus.add(otherCVDList[i].toString());
        }
      }

    }
    if(additionalConditionChecboxStatus != null){
      if(additional_condition_others_check){
        for(int i = 0; i < additionalConditionList.length; i++){
          additionalConditionChecboxStatus.add(additionalConditionList[i].toString());
        }
      }
    }
    if(familyConditionCheckboxStatus != null){
      if(family_condition_others_check){
        for(int i = 0; i < familyConditionList.length; i++){
          familyConditionCheckboxStatus.add(familyConditionList[i].toString());
        }
      }
    }
  }
}


//other cvd
class OtherCVDTextFields extends StatefulWidget {
  final int index;
  OtherCVDTextFields(this.index);
  @override
  _OtherCVDFieldsState createState() => _OtherCVDFieldsState();
}

// additional conditions
class AdditionalConditionsTextFields extends StatefulWidget {
  final int index;
  AdditionalConditionsTextFields(this.index);
  @override
  _AdditionalConditionsTextFieldsState createState() => _AdditionalConditionsTextFieldsState();
}

class FamilyConditionsTextFields extends StatefulWidget {
  final int index;
  FamilyConditionsTextFields(this.index);
  @override
  _FamilyConditionsTextFieldsState createState() => _FamilyConditionsTextFieldsState();
}

class _OtherCVDFieldsState extends State<OtherCVDTextFields> {
  TextEditingController _nameControllerOtherCVD;

  @override
  void initState() {
    super.initState();
    _nameControllerOtherCVD = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerOtherCVD.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerOtherCVD.text = _MedicalHistoryState.otherCVDList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerOtherCVD,
      onChanged: (v) => _MedicalHistoryState.otherCVDList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your other Cardiovascular Disease'
      ),
      validator: (f){
        if(f.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }


}

// additional conditions after this
class _AdditionalConditionsTextFieldsState extends State<AdditionalConditionsTextFields> {
  TextEditingController _nameControllerAdditionalConditions;

  @override
  void initState() {
    super.initState();
    _nameControllerAdditionalConditions = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerAdditionalConditions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerAdditionalConditions.text = _MedicalHistoryState.additionalConditionList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerAdditionalConditions,
      onChanged: (v) => _MedicalHistoryState.additionalConditionList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your Other Medical Conditions'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
//family condition after this
class _FamilyConditionsTextFieldsState extends State<FamilyConditionsTextFields> {
  TextEditingController _nameControllerFamilyConditions;

  @override
  void initState() {
    super.initState();
    _nameControllerFamilyConditions = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerFamilyConditions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerFamilyConditions.text = _MedicalHistoryState.familyConditionList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerFamilyConditions,
      onChanged: (v) => _MedicalHistoryState.familyConditionList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter Family Medical Conditions'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}



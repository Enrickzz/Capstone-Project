import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/checkbox_state.dart';
import 'package:my_app/services/auth.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class set_up extends StatefulWidget {
  @override
  _set_upState createState() => _set_upState();
}

class _set_upState extends State<set_up> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  final FirebaseAuth auth = FirebaseAuth.instance;
  String error = '';
  int currentStep = 0;

  /// additional information
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  var dateValue = TextEditingController();

  /// allergies
  TextEditingController _nameController;
  TextEditingController _nameControllerFoods;
  TextEditingController _nameControllerDrugs;
  TextEditingController _nameControllerOthers;
  static List<String> foodList = [null];
  static List<String> drugList = [null];
  static List<String> otherList = [null];

  /// goal weight
  bool isSwitched = false;
  bool isSwitchedLifestyle = false;
  bool isSwitchedSmoker = false;
  bool isSwitchedDrinker = false;

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

  String valueAlcohol;

  List<String> listAlcohol = <String>[
    'Never',
    'Rarely',
    'Sometimes',
    'Often',
    'Always'
  ];

  /// allergies
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Widget> _getFoodAllergies(){
    List<Widget> foodsTextFields = [];
    for(int i=0; i<foodList.length; i++){
      foodsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: FoodTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonFood(i == foodList.length-1, i),
              ],
            ),
          )
      );
    }
    return foodsTextFields;
  }

  // add / remove button
  Widget _addRemoveButtonFood(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          foodList.insert(0, null);
        }
        else foodList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  //drugs after this
  /// get firends text-fields
  List<Widget> _getDrugs(){
    List<Widget> drugsTextFields = [];
    for(int i=0; i<drugList.length; i++){
      drugsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: DrugsTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonDrugs(i == drugList.length-1, i),
              ],
            ),
          )
      );
    }
    return drugsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonDrugs(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          drugList.insert(0, null);
        }
        else drugList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  //Others after this
  /// get others text-fields
  List<Widget> _getOthers(){
    List<Widget> othersTextFields = [];
    for(int i=0; i<otherList.length; i++){
      othersTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: OtherTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonOther(i == otherList.length-1, i),
              ],
            ),
          )
      );
    }
    return othersTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonOther(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          otherList.insert(0, null);
        }
        else otherList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );

  }

  /// medical history
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
  List<String> familyConditionChecboxStatus = [];
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

    List<Step> getSteps() => [
      Step( /// additional information screen
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text(''),

        content: Container(
          child: Form(
            key: formKeys[0],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text("Additional Information",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  margin: EdgeInsets.only(bottom: 30),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: ()async{
                    final datePick= await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime(2100)
                    );
                    if(datePick!=null && datePick!=birthDate){
                      setState(() {
                        birthDate=datePick;
                        isDateSelected=true;

                        // put it here
                        birthDateInString = "${birthDate.month}/${birthDate.day}/${birthDate.year}";
                        dateValue.text = birthDateInString;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateValue,
                      showCursor: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width:0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Birthday *",
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'Select Birthday' : null,
                      onChanged: (val){

                        print(dateValue);
                        setState((){
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.accessibility_rounded,
                      color: Color(0xFF666666),
                      size: defaultIconSize,
                    ),
                    fillColor: Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize),
                    hintText: "Weight (kg) *",
                  ),
                  validator: (val) => val.isEmpty ? 'Enter Weight in KG' : null,
                  onChanged: (val){
                    setState(() => weight = val);
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly],
                  // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                  // onChanged: (val){
                  //   setState(() => genderIn = val);
                  // },
                ),SizedBox(
                  height: 8,
                ),
                TextFormField(
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.accessibility_rounded,
                      color: Color(0xFF666666),
                      size: defaultIconSize,
                    ),
                    fillColor: Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize),
                    hintText: "Height (cm) *",
                  ),
                  validator: (val) => val.isEmpty ? 'Enter Height in cm' : null,
                  onChanged: (val){
                    setState(() => height = val);
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly],
                  // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                  // onChanged: (val){
                  //   setState(() => genderIn = val);
                  // },
                ),SizedBox(
                  height: 8,
                ),
                GenderPickerWithImage(
                  showOtherGender: true,
                  verticalAlignedText: true,
                  selectedGender: Gender.Male,
                  selectedGenderTextStyle: TextStyle(
                      color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                  unSelectedGenderTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  onChanged: (Gender gender) {
                    print(gender);
                    List<String> strArr = gender.toString().split(".");
                    genderIn = strArr[1];
                  },
                  equallyAligned: true,
                  animationDuration: Duration(milliseconds: 300),
                  isCircular: true,
                  // default : true,
                  opacityOfGradient: 0.4,
                  padding: const EdgeInsets.all(3),
                  size: 50, //default : 40
                ),
              ],
            ),
          ),
        ),
      ),
      Step( /// allergies screen
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text(''),

        content: Container(
          child: Form(
            key: formKeys[1],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text("Allergies",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(height: 16,),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Food Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),)),
                SizedBox(height: 8,),
                ..._getFoodAllergies(),
                SizedBox(height: 16,),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Drug Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),)),
                SizedBox(height: 8,),
                ..._getDrugs(),
                SizedBox(height: 16,),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Other Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),)),
                SizedBox(height: 8,),
                ..._getOthers(),
              ],
            )
          )
        ),
      ),
      Step( /// goal weight screen
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(''),

        content: Container(
          child: Form(
            key: formKeys[2],
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 30),
                    child: Text("Goal Setting",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SwitchListTile(
                    title: Text('My Weight Goals', style: TextStyle(fontSize: 14.0)),
                    subtitle: Text('I want to set my weight goals', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons.accessibility_new_outlined, size: 34.0, color: Colors.green),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isSwitched,
                    onChanged: (value){
                      setState(() {
                        isSwitched = value;

                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(height: 8.0),
                  Visibility(
                    visible: isSwitched,
                    child: TextFormField(
                      showCursor: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width:0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "What is my weight goal? *",
                        prefixIcon: Icon(
                          Icons.add_reaction_outlined,
                          color: Color(0xFF666666),
                          size: 22,
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'My weight goal is' : null,
                      onChanged: (val){
                        setState(() => goal = val);

                      },
                    ),
                  ),
                  Visibility(
                    visible: isSwitched,
                    child: ToggleButtons(
                      isSelected: isSelected,
                      highlightColor: Colors.blue,
                      children: <Widget> [
                        Padding (
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ibs')
                        ),
                        Padding (
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('kg')
                        ),
                      ],
                      onPressed:(int newIndex){
                        setState(() {
                          for (int index = 0; index < isSelected.length; index++){
                            if (index == newIndex) {
                              isSelected[index] = true;
                              print("mmol/L");
                            } else {
                              isSelected[index] = false;
                              print("mg/dL");
                            }
                          }
                          // if(newIndex == 0 && unitStatus != "mmol/L"){
                          if(newIndex == 0){
                            print("ibs");
                            unitStatus = "mmol/L";
                            // unitValue.text = glucose.toStringAsFixed(2);
                            // print(glucose.toStringAsFixed(2));
                          }
                          // if(newIndex == 1 && unitStatus != "mg/dL"){
                          if(newIndex == 1){
                            print("kg");
                            unitStatus = "mg/dL";
                            // glucose = glucose / 18;
                            // unitValue.text = glucose.toStringAsFixed(2);
                            // print(glucose.toStringAsFixed(2));
                          }
                        });
                      },
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100)
                      ).then((value){
                        if(value != null && value != prescriptionDate){
                          setState(() {
                            prescriptionDate = value;
                            isDateSelected = true;
                            startdate = "${prescriptionDate.month}/${prescriptionDate.day}/${prescriptionDate.year}";
                          });
                          startDate.text = startdate + "\r";
                        }
                      });
                    },
                    child: Visibility(
                      visible: isSwitched,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: startDate,
                          showCursor: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width:0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "When do I need to accomplish this goal? *",
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xFF666666),
                              size: defaultIconSize,
                            ),
                          ),
                          validator: (val) => val.isEmpty ? 'Select Date' : null,
                          onChanged: (val){

                            print(startDate);
                            setState((){
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 30, top: 50),
                    child: Text("Lifestyle",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "My Lifestyle *",
                    ),
                    isExpanded: true,
                    value: valueLifestyle,
                    onChanged: (newValue){
                      setState(() {
                        valueLifestyle = newValue;
                      });
                    },
                    items: listLifestyle.map((valueItem){
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem)
                      );
                    },
                    ).toList(),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  SwitchListTile(
                    title: Text('Show Lifestyles', style: TextStyle(fontSize: 14.0)),
                    subtitle: Text('What are the lifestyles?', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons.accessibility_new_outlined, size: 34.0, color: Colors.green),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isSwitchedLifestyle,
                    onChanged: (value){
                      setState(() {
                        isSwitchedLifestyle = value;

                      });
                    },
                  ),

                  Visibility(
                    visible: isSwitchedLifestyle,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _createDataTable(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SwitchListTile(
                    title: Text('Smoking', style: TextStyle(fontSize: 14.0)),
                    subtitle: Text('I am a smoker', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons.smoking_rooms, size: 34.0, color: Colors.red),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isSwitchedSmoker,
                    onChanged: (value){
                      setState(() {
                        isSwitchedSmoker = value;

                      });
                    },
                  ),
                  Visibility(
                    visible: isSwitchedSmoker,
                    child: TextFormField(
                      showCursor: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width:0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Average sticks per day? *",
                        prefixIcon: Icon(
                          Icons.smoking_rooms,
                          color: Color(0xFF666666),
                          size: 22,
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'Enter number of sticks' : null,
                      onChanged: (val){
                        setState(() => goal = val);

                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "When do I drink alcohol? *",
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                    ),
                    isExpanded: true,
                    value: valueAlcohol,
                    onChanged: (newValue){
                      setState(() {
                        valueAlcohol = newValue;
                      });
                    },
                    items: listAlcohol.map((valueItem){
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem)
                      );
                    },
                    ).toList(),
                  ),
                ]
            ),
          ),
        ),
      ),

      Step( /// medical history screen
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(''),

        content: Container(
          child: Form(
            key: formKeys[3],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text("Medical History",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  margin: EdgeInsets.only(bottom: 30),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("What kind of Cardiovascular disease do you have? (choose all that applies)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ),
                ...cvd_list.map(buildSingleCheckboxCVD).toList(),
                ...cvdOthers.map(buildSingleCheckboxCVDOthers).toList(),
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: cvd_others_check,
                  child: Text('Other Cardiovascular Diseases', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                ..._getOtherCVD(),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text("Do you have any other medical conditions? (choose all that applies)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ),
                ...additional_list.map(buildSingleCheckboxAdditionalConditions).toList(),
                ...additionalConditionOthers.map(buildSingleCheckboxAdditionalConditionsOthers).toList(),

                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: additional_condition_others_check,
                  child: Text('Other Medical Conditions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                ..._getAdditionalConditions(),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text("Any family members with medical conditions? (choose all that applies)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ),
                ...family_condition_list.map(buildSingleCheckboxFamilyConditions).toList(),
                ...faimlyConditionOthers.map(buildSingleCheckboxFamilyConditionsOthers).toList(),
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: family_condition_others_check,
                  child: Text('Family History Medical Conditions',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                ..._getFamilyConditions()
              ],
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Set Up Your Account', style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          print(currentStep);

          if (isLastStep) {
            print("Completed");

            // try{
            //   final User user = auth.currentUser;
            //   final uid = user.uid;
            //   final usersRef = databaseReference.child('users/' + uid + '/vitals/additional_info');
            //   final loginRef = databaseReference.child('users/' + uid + '/personal_info');
            //   usersRef.set({"birthday": birthDateInString.toString(), "gender": genderIn.toString(), "weight": weight.toString(), "height":height.toString(),"BMI": "0"});
            //   print("Additional information collected!");
            //
            //   final foodRef = databaseReference.child('users/' + uid + '/vitals/additional_info/food_allergies/');
            //   final drugRef = databaseReference.child('users/' + uid + '/vitals/additional_info/drug_allergies/');
            //   final otherRef = databaseReference.child('users/' + uid + '/vitals/additional_info/other_allergies/');
            //
            //   if(foodList != null){
            //     for(int i = 0; i < foodList.length; i++){
            //       foodRef.set({"food_allergy " + i.toString(): foodList[i]});
            //     }
            //   }
            //   if(drugList != null){
            //     for(int i = 0; i < drugList.length; i++){
            //       drugRef.set({"drug_allergy " + i.toString(): drugList[i]});
            //     }
            //   }
            //   if(otherList != null){
            //     for(int i = 0; i < otherList.length; i++){
            //       otherRef.set({"other_allergy " + i.toString(): otherList[i]});
            //     }
            //   }
            //
            //   loginRef.update({"isFirstTime": "false"});
            //
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => mainScreen()),
            //   );
            //
            // } catch(e) {
            //   print("you got an error! $e");
            // }
            //   print("birthday: " + birthDateInString.toString() + "gender: " + genderIn.toString() + "weight " + weight.toString() + "height " + height.toString() + "BMI 0");



          } else {

            setState(() => currentStep += 1);
            // if (formKeys[0].currentState.validate() && currentStep == 0) {
            //   setState(() => currentStep += 1);
            // }
            // else if (currentStep == 1) {
            //   setState(() => currentStep += 1);
            // }
            // else if (formKeys[2].currentState.validate() && currentStep == 2) {
            //   setState(() => currentStep += 1);
            // }

          }
        },
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
          // if (formKeys[0].currentState.validate() && currentStep == 0) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // }
          // else if (currentStep == 1) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (formKeys[2].currentState.validate() && currentStep == 2) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (currentStep == 3) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // }
        },
        onStepCancel:
            currentStep == 0 ? null : () => setState(() => currentStep -= 1),


        // controlsBuilder: (context, {onStepContinue, onStepCancel}) {
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          final isLastStep = currentStep == getSteps().length - 1;
          print(currentStep);

          return Container(
            margin: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  if (currentStep != 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('BACK'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepContinue,
                      child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                    ),
                  ),
                ],
              ),
          );
        },

      ),
    );
  }

  /// medical history
  Widget buildSingleCheckboxCVD(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: CheckboxListTile(
      activeColor: Colors.green,
      value: checkbox.value,
      title: Text(
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
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
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
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
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
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
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
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
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
      ),

      onChanged: (value) => setState(() => {
        checkbox.value = value,
        if(checkbox.value){
          familyConditionChecboxStatus.add(checkbox.title),
        }
        else{
          for(int i = 0; i < familyConditionChecboxStatus.length; i++){
            if(familyConditionChecboxStatus[i] == checkbox.title){
              familyConditionChecboxStatus.removeAt(i)
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
          checkbox.title,
          style: TextStyle(fontSize: 14.0)
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
          color: (add) ? Colors.blue : Colors.red,
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
          color: (add) ? Colors.blue : Colors.red,
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
          color: (add) ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
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
      _nameControllerOtherCVD.text = _set_upState.otherCVDList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerOtherCVD,
      onChanged: (v) => _set_upState.otherCVDList[widget.index] = v,
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
      _nameControllerAdditionalConditions.text = _set_upState.additionalConditionList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerAdditionalConditions,
      onChanged: (v) => _set_upState.additionalConditionList[widget.index] = v,
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
      _nameControllerFamilyConditions.text = _set_upState.familyConditionList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerFamilyConditions,
      onChanged: (v) => _set_upState.familyConditionList[widget.index] = v,
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



  /// goal weight
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


/// allergies

class FoodTextFields extends StatefulWidget {
  final int index;
  FoodTextFields(this.index);
  @override
  _FoodTextFieldsState createState() => _FoodTextFieldsState();
}

class DrugsTextFields extends StatefulWidget {
  final int index;
  DrugsTextFields(this.index);
  @override
  _DrugsTextFieldsState createState() => _DrugsTextFieldsState();
}

class OtherTextFields extends StatefulWidget {
  final int index;
  OtherTextFields(this.index);
  @override
  _OtherTextFieldsState createState() => _OtherTextFieldsState();
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
      _nameControllerFoods.text = _set_upState.foodList[widget.index] ?? '';
    });


    return TextFormField(
      controller: _nameControllerFoods,
      onChanged: (v) => _set_upState.foodList[widget.index] = v,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14),
        hintText: "Enter your food allergies",
      ),
      validator: (f){
        if(f.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );



  }

}


///allergies
//drugs after this
class _DrugsTextFieldsState extends State<DrugsTextFields> {
  TextEditingController _nameControllerDrugs;

  @override
  void initState() {
    super.initState();
    _nameControllerDrugs = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerDrugs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerDrugs.text = _set_upState.drugList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerDrugs,
      onChanged: (v) => _set_upState.drugList[widget.index] = v,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14),
        hintText: "Enter your drug allergies",
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

//others after this
class _OtherTextFieldsState extends State<OtherTextFields> {
  TextEditingController _nameControllerOthers;

  @override
  void initState() {
    super.initState();
    _nameControllerOthers = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerOthers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerOthers.text = _set_upState.otherList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerOthers,
      onChanged: (v) => _set_upState.otherList[widget.index] = v,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14),
        hintText: "Enter your other allergies",
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
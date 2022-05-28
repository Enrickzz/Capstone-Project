import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
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
  DateTime now = new DateTime.now();
  /// additional information
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "";
  String weight = "";
  String height = "";
  String genderIn="male";
  var dateValue = TextEditingController();

  /// allergies
  TextEditingController _nameController;
  TextEditingController _nameControllerFoods;
  TextEditingController _nameControllerDrugs;
  TextEditingController _nameControllerOthers;
  static List<String> foodList = [];
  static List<String> drugList = [];
  static List<String> otherList = [];

  /// goal weight
  bool isSwitched = false;
  bool isSwitchedLifestyle = false;
  bool isSwitchedSmoker = false;
  bool isSwitchedDrinker = false;

  String weight_goal = '';
  String water_goal = '';
  DateTime prescriptionDate;
  var goalDate = TextEditingController();
  String goaldate = "";
  List <bool> isSelected = [true, false];
  List <bool> isSelectedWater = [true, false];
  String unitStatus = "kg";
  String valueLifestyle;
  int average_sticks = 0;
  List<String> disease_list = ["NA", "NA"];

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
    foodList.clear();
    foodList.add(null);
    drugList.clear();
    drugList.add(null);
    otherList.clear();
    otherList.add(null);
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
  List<String> cvdChecboxStatus = ["NA", "NA"];

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
  List<String> additionalConditionChecboxStatus = ["NA", "NA"];

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
  List<String> familyConditionCheckboxStatus = ["NA", "NA"];

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

  //weight goals
  bool goalSelected = false;
  String valueChooseWeightGoal; // lose gain maintain
  List<String> listWeightGoal = <String>[
    'Lose', 'Gain', 'Maintain',
  ];
  String weight_unit = 'Kilograms';

  //water intake goals

  String water_unit = 'Milliliter';



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
                        initialDate: DateTime(1990, 1),
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime.now()
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
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Weight Goals",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                      hintText: "My goal is to _________ weight ",
                    ),
                    isExpanded: true,
                    value: valueChooseWeightGoal,
                    onChanged: (newValue){
                      setState(() {
                        valueChooseWeightGoal = newValue;
                        goalSelected= true;



                      });

                    },
                    items: listWeightGoal.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Visibility(
                    visible: goalSelected,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            showCursor: true,
                            keyboardType: TextInputType.number,
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
                              hintText: "My target weight is: ",
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Weight Goal' : null,
                            onChanged: (val){
                               weight_goal = val;
                              // setState(() => temperature = double.parse(val));
                            },
                          ),
                        ),
                        SizedBox(width: 8,),
                        ToggleButtons(
                          isSelected: isSelected,
                          highlightColor: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          children: <Widget> [
                            Padding (
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('kg')
                            ),
                            Padding (
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('lbs')
                            ),
                          ],
                          onPressed:(int newIndex){
                            setState(() {
                              for (int index = 0; index < isSelected.length; index++){
                                if (index == newIndex) {
                                  isSelected[index] = true;
                                  print("Kilograms (kg)");
                                } else {
                                  isSelected[index] = false;
                                  print("Pounds (lbs)");
                                }
                              }
                              if(newIndex == 0){
                                print("Kilograms (kg)");
                                weight_unit = "Kilograms";
                              }
                              if(newIndex == 1){
                                print("Pounds (lbs)");
                                weight_unit = "Pounds";

                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Water Intake Goals",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          keyboardType: TextInputType.number,
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
                            hintText: "Daily Water Intake Goals",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Water Intake Goal' : null,
                          onChanged: (val){
                            water_goal = val;
                            // setState(() => temperature = double.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 8,),
                      ToggleButtons(
                        isSelected: isSelectedWater,
                        highlightColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('ml')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('oz')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelectedWater.length; index++){
                              if (index == newIndex) {
                                isSelectedWater[index] = true;
                                print("Milliliter (ml)");
                              } else {
                                isSelectedWater[index] = false;
                                print("Ounce (oz)");
                              }
                            }
                            if(newIndex == 0){
                              print("Milliliter (ml)");
                              water_unit = "Milliliter";
                            }
                            if(newIndex == 1){
                              print("Ounce (oz)");
                              water_unit = "Ounce";

                            }
                          });
                        },
                      ),
                    ],
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
                            goaldate = "${prescriptionDate.month}/${prescriptionDate.day}/${prescriptionDate.year}";
                          });
                          goalDate.text = goaldate + "\r";
                        }
                      });
                    },
                    child: Visibility(
                      visible: isSwitched,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: goalDate,
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
                            goaldate = val;
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
                        setState(() => average_sticks = int.parse(val));

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
                ..._getOtherCVD(),

                SizedBox(
                  height: 24,
                ),

                Container(
                  alignment: Alignment.center,
                  child: Text("Do you have any other medical conditions? (choose all that applies)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ),
                ...additional_list.map(buildSingleCheckboxAdditionalConditions).toList(),
                ...additionalConditionOthers.map(buildSingleCheckboxAdditionalConditionsOthers).toList(),
                ..._getAdditionalConditions(),

                SizedBox(
                  height: 24,
                ),

                Container(
                  alignment: Alignment.center,
                  child: Text("Any family members with medical conditions? (choose all that applies)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ),
                ...family_condition_list.map(buildSingleCheckboxFamilyConditions).toList(),
                ...faimlyConditionOthers.map(buildSingleCheckboxFamilyConditionsOthers).toList(),
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
            getOtherDisease();

            try{
              double bmi = double.parse(weight) / ((double.parse(height)* 0.01) * (double.parse(height)* 0.01));
              print("BMIII" + bmi.toString());
              if(weight_unit == "Pounds"){
                weight_goal = (double.parse(weight_goal) * 0.45359237).toStringAsFixed(1);
                weight_unit = "Kilograms";
              }
              if(water_unit == "Ounce"){
                water_goal = (double.parse(water_goal) * 29.5735).toStringAsFixed(1);
                water_unit = "Milliliter";
              }
              Future.delayed(const Duration(milliseconds: 1000), () {
                final User user = auth.currentUser;
                final uid = user.uid;
                final usersRef = databaseReference.child('users/' + uid + '/vitals/additional_info/');
                final loginRef = databaseReference.child('users/' + uid + '/personal_info/');
                final physicalRef = databaseReference.child('users/' + uid + '/physical_parameters/');
                final weightGoalRef = databaseReference.child('users/' + uid + '/goal/weight_goal/');
                final weightRef = databaseReference.child('users/' + uid + '/goal/weight/1');
                final waterRef = databaseReference.child('users/' + uid + '/goal/water_goal/');
                final sleepRef = databaseReference.child('users/' + uid + '/goal/sleep_goal/');
                final fitbitRef = databaseReference.child('users/' + uid + '/fitbit_connection/');
                final spotifyRef = databaseReference.child('users/' + uid + '/spotify_connection/');
                final ihealthRef = databaseReference.child('users/' + uid + '/ihealth_connection/');
                final vitalsConnectionRef = databaseReference.child('users/' + uid + '/vitals_connection/');
                final stressRef = databaseReference.child('users/' + uid + '/goal/stress_goal/');
                bool diseasecheck = false;
                bool otherdiseasecheck = false;
                bool familydiseasecheck = false;
                var counter1 = 0;
                var counter2 = 0;
                var counter3 = 0;
                if(cvdChecboxStatus.length != 2){
                  while(!diseasecheck){
                    if(cvdChecboxStatus[counter1] == "NA"){
                      cvdChecboxStatus.removeAt(counter1);
                      counter1 = 0;
                    }
                    else{
                      counter1++;
                    }
                    if(counter1 == cvdChecboxStatus.length){
                      diseasecheck = true;
                    }
                  }
                }
                if(additionalConditionChecboxStatus.length != 2){
                  while(!otherdiseasecheck){
                    if(additionalConditionChecboxStatus[counter2] == "NA"){
                      additionalConditionChecboxStatus.removeAt(counter2);
                      counter2 = 0;
                    }
                    else{
                      counter2++;
                    }
                    if(counter2 == additionalConditionChecboxStatus.length){
                      otherdiseasecheck = true;
                    }
                  }
                }
                if(familyConditionCheckboxStatus.length != 2){
                  while(!familydiseasecheck){
                    if(familyConditionCheckboxStatus[counter3] == "NA"){
                      familyConditionCheckboxStatus.removeAt(counter3);
                      counter3 = 0;
                    }
                    else{
                      counter3++;
                    }
                    if(counter3 == familyConditionCheckboxStatus.length){
                      familydiseasecheck = true;
                    }
                  }
                }
                if(foodList[0] == null){
                  foodList.add("NA");
                  foodList.add("NA");
                }
                if(foodList[0] == ""){
                  foodList.remove(0);
                  foodList.add("NA");
                  foodList.add("NA");
                }
                if(drugList[0] == null){
                  drugList.add("NA");
                  drugList.add("NA");
                }
                if(drugList[0] == ""){
                  drugList.remove(0);
                  drugList.add("NA");
                  drugList.add("NA");
                }
                if(otherList[0] == null){
                  otherList.add("NA");
                  otherList.add("NA");
                }
                if(otherList[0] == ""){
                  otherList.remove(0);
                  otherList.add("NA");
                  otherList.add("NA");
                }
                usersRef.set({
                  "birthday": birthDateInString.toString(),
                  "gender": genderIn.toString(),
                  "foodAller": foodList,
                  "drugAller": drugList,
                  "otherAller": otherList,
                  "lifestyle": valueLifestyle,
                  "average_stick": average_sticks.toString(),
                  "alcohol_freq": valueAlcohol,
                  "disease": cvdChecboxStatus,
                  "other_disease": additionalConditionChecboxStatus,
                  "family_disease": familyConditionCheckboxStatus
                });
                physicalRef.set({
                  "BMI": bmi.toStringAsFixed(1),
                  "height":height.toString(),
                  "weight": weight.toString(),
                });
                loginRef.update({"isFirstTime": false});
                weightGoalRef.set({
                  "objective": valueChooseWeightGoal,
                  "target_weight": weight_goal.toString(),
                  "current_weight": weight.toString(),
                  "weight": weight.toString(),
                  "weight_unit": weight_unit,
                  "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                });
                weightRef.set({
                  "weight": weight.toString(),
                  "bmi": bmi.toStringAsFixed(1),
                  "timeCreated": "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2,"0")}",
                  "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                });
                waterRef.set({
                  "water_goal": water_goal,
                  "water_unit": water_unit,
                  "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                });
                sleepRef.set({
                  "bed_time" : "00:00",
                  "wakeup_time": "08:00",
                  "duration": "480",
                  "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                });
                fitbitRef.set({"isConnected": false});
                spotifyRef.set({"isConnected": false});
                ihealthRef.set({"isConnected": false});
                vitalsConnectionRef.set({"uid": uid, "bloodpressure": "false", "bloodglucose": "false","heartrate": "false","respiratoryrate": "false","oxygensaturation": "false","bodytemperature": "false"});
                print("Completed " + uid);
              });

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => mainScreen()),
              );

            //
            } catch(e) {
              print("you got an error! $e");
            }
            //   print("birthday: " + birthDateInString.toString() + "gender: " + genderIn.toString() + "weight " + weight.toString() + "height " + height.toString() + "BMI 0");



          } else {

            // setState(() => currentStep += 1);
            if (formKeys[0].currentState.validate() && currentStep == 0) {
              setState(() => currentStep += 1);
            }
            else if (currentStep == 1) {
              setState(() => currentStep += 1);
            }
            else if (formKeys[2].currentState.validate() && currentStep == 2) {
              setState(() => currentStep += 1);
            }
            else if (formKeys[3].currentState.validate() && currentStep == 3) {
              setState(() => currentStep += 1);
            }

          }
        },
        onStepTapped: (step) {
          // setState(() {
          //   currentStep = step;
          // });
          if (formKeys[0].currentState.validate() && currentStep == 0) {
            setState(() {
              currentStep = step;
            });
          }
          else if (currentStep == 1) {
            setState(() {
              currentStep = step;
            });
          } else if (formKeys[2].currentState.validate() && currentStep == 2) {
            setState(() {
              currentStep = step;
            });
          } else if (formKeys[3].currentState.validate() && currentStep == 3) {
            setState(() {
              currentStep = step;
            });
          }

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
    child: SizedBox(
      height:45,
      child: CheckboxListTile(
        activeColor: Colors.blue,
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
    ),
  );

  Widget buildSingleCheckboxCVDOthers(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: SizedBox(
      height: 45,

      child: CheckboxListTile(
        activeColor: Colors.blue,
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
    ),
  );

  Widget buildSingleCheckboxAdditionalConditions(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: SizedBox(
      height: 45,
      child: CheckboxListTile(
        activeColor: Colors.blue,
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
    ),
  );

  Widget buildSingleCheckboxAdditionalConditionsOthers(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: SizedBox(
      height: 45,
      child: CheckboxListTile(
        activeColor: Colors.blue,
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
    ),
  );
  Widget buildSingleCheckboxFamilyConditions(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: SizedBox(
      height: 45,
      child: CheckboxListTile(
        activeColor: Colors.blue,
        value: checkbox.value,
        title: Text(
            checkbox.title,
            style: TextStyle(fontSize: 14.0)
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
    ),
  );

  Widget buildSingleCheckboxFamilyConditionsOthers(CheckBoxState checkbox) =>  Visibility(
    visible: true,
    child: SizedBox(
      height: 45,
      child: CheckboxListTile(
        activeColor: Colors.blue,
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
    ),
  );

  List<Widget> _getOtherCVD(){
    List<Widget> otherCVDsTextFields = [];
    for(int i=0; i<otherCVDList.length; i++){
      otherCVDsTextFields.add(
          Visibility(
            visible: cvd_others_check,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
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
              padding: const EdgeInsets.symmetric(vertical: 4.0),
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
              padding: const EdgeInsets.symmetric(vertical: 4.0),
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
      _nameControllerOtherCVD.text = _set_upState.otherCVDList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerOtherCVD,
      onChanged: (v) => _set_upState.otherCVDList[widget.index] = v,
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
        hintText: "Enter your other cardiovascular disease",
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
        hintText: "Enter your other medical condition",
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
        hintText: "Enter family medical condition",
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
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          color: (add) ? Colors.green : Colors.red,
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          color: (add) ? Colors.green : Colors.red,
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );

  }

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
                        hintText: "Birthday",
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
                    hintText: "Weight in KG",
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
                    hintText: "Height in cm",
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
                  child: Text("Allergies",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Food Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ..._getFoodAllergies(),
                SizedBox(height: 20,),
                Text('Drug Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ..._getDrugs(),
                SizedBox(height: 20,),
                Text('Other Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),),
                ..._getOthers(),
                SizedBox(height: 40,),
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
                    child: Text("Goal Weight",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SwitchListTile(
                    title: Text('My Weight Goals'),
                    subtitle: Text('I want to set my Weight Goals'),
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
                        hintText: "What is my weight goal?",
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
                            hintText: "When do I need to accomplish this goal?",
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xFF666666),
                              size: defaultIconSize,
                            ),
                          ),
                          validator: (val) => val.isEmpty ? 'Select Start Date' : null,
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
                      hintText: "My Lifestyle:",
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
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
                    title: Text('Show Lifestyles'),
                    subtitle: Text('What Lifestyles?'),
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
                    title: Text('Smoking'),
                    subtitle: Text('I am a smoker'),
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
                        hintText: "Average sticks per day?",
                        prefixIcon: Icon(
                          Icons.smoking_rooms,
                          color: Color(0xFF666666),
                          size: 22,
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'Number of sticks' : null,
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
                      hintText: "When do I drink alcohol?",
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
      Step( /// medical history scre
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(''),

        content: Container(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Up Your Account'),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
            // if (formKeys[0].currentState.validate() && currentStep == 0)
            setState(() => currentStep += 1);

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
          // } else if (currentStep == 1) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (currentStep == 2) {
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


        controlsBuilder: (context, {onStepContinue, onStepCancel}) {
          final isLastStep = currentStep == getSteps().length - 1;
          print(currentStep);

          return Container(
            margin: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  if (currentStep != 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onStepCancel,
                      child: const Text('BACK'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onStepContinue,
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
          hintText: 'Enter your Food Allergies'
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
          hintText: 'Enter your Medicine Allergies'
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
          hintText: 'Enter your Other Allergies'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
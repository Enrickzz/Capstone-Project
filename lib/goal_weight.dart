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
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class goalWeight extends StatefulWidget {
  @override
  _GoalWeightState createState() => _GoalWeightState();
}

class _GoalWeightState extends State<goalWeight> {
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
                      child: Text("Additional Information",
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
                          hintText: "What is my Weight Goal?",
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
                    DropdownButton(
                      dropdownColor: Colors.white,
                      hint: Text("My Lifestyle: "),
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                      iconSize: 36,
                      isExpanded: true,
                      underline: SizedBox(),
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _createDataTable(),
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
                    DropdownButton(
                      dropdownColor: Colors.white,
                      hint: Text("When do I drink Alcohol? "),
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                      iconSize: 36,
                      isExpanded: true,
                      underline: SizedBox(),
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
                    



                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(17.0),
                        onPressed: ()  {

                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final usersRef = databaseReference.child('users/' + uid + '/vitals/additional_info');
                            final loginRef = databaseReference.child('users/' + uid + '/personal_info');
                            usersRef.set({"birthday": birthDateInString.toString(), "gender": genderIn.toString(), "weight": weight.toString(), "height":height.toString(),"BMI": "0"});
                            print("Additional information collected!");
                            loginRef.update({"isFirstTime": "false"});
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => mainScreen()),
                            );


                          } catch(e) {
                            print("you got an error! $e");
                          }
                          print("birthday: " + birthDateInString.toString() + "gender: " + genderIn.toString() + "weight " + weight.toString() + "height " + height.toString() + "BMI 0");

                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins-Medium.ttf',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        color: Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            side: BorderSide(color: Color(0xFF2196F3))),
                      ),

                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF2196F3)),

                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 8,
                    ),
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
}



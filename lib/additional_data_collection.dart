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
class additional_data_collection extends StatefulWidget {
  @override
  _AppSignUpState createState() => _AppSignUpState();
}

class _AppSignUpState extends State<additional_data_collection> {
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

  String genderIn="mygender";
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Row(
                      children: <Widget>[
                        GestureDetector(
                            child: new Icon(Icons.calendar_today),
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
                                  birthDateInString = "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                                  AlertDialog alert = AlertDialog(
                                    title: Text("My title"),
                                    content: Text("This is my message."),
                                    actions: [

                                    ],
                                  );

                                });
                              }
                            }
                        ), Container(
                          child: Text(
                              " MM/DD/YYYY ",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize,
                                fontStyle: FontStyle.normal,
                              )
                          )
                        ),
                      ],
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly],
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val){
                        setState(() => genderIn = val);
                      },
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
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(17.0),
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Contents"),
                                  content: Text("Birthdate: "+birthDateInString +"\nGender: "+genderIn));
                              },
                          )

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
}

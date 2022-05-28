
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_personal_information extends StatefulWidget {
  // final List<FoodPlan> thislist;
  // final String userUID;
  edit_personal_information();
  @override
  _editPersonalInformation createState() => _editPersonalInformation();
}
final _formKey = GlobalKey<FormState>();
class _editPersonalInformation extends State<edit_personal_information> {


  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();


  final _formKey = GlobalKey<FormState>();

  String firstname = "";
  String lastname = "";
  String weight = "";
  String height = "";

  //birthday
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "";
  bool isDateSelected= false;
  var dateValue = TextEditingController();


  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        key: _formKey,
        color: Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Edit My Personal Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "First Name *",
                          ),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Enter First Name'
                              : null,
                          onChanged: (val) {
                            setState(() => firstname = val);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "Last Name *",
                          ),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Enter Last Name'
                              : null,
                          onChanged: (val) {
                            setState(() => lastname = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1990, 1),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime.now()
                      );
                      if (datePick != null && datePick != birthDate) {
                        setState(() {
                          birthDate = datePick;
                          isDateSelected = true;
                          // put it here
                          birthDateInString =
                          "${birthDate.month}/${birthDate.day}/${birthDate
                              .year}";
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
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
                        validator: (val) =>
                        val.isEmpty
                            ? 'Select Birthday'
                            : null,
                        onChanged: (val) {
                          print(dateValue);
                          setState(() {

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
                    validator: (val) =>
                    val.isEmpty
                        ? 'Enter Weight in KG'
                        : null,
                    onChanged: (val) {
                      setState(() => weight = val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly],
                    // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    // onChanged: (val){
                    //   setState(() => genderIn = val);
                    // },
                  ), SizedBox(
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
                    validator: (val) =>
                    val.isEmpty
                        ? 'Enter Height in cm'
                        : null,
                    onChanged: (val) {
                      setState(() => height = val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly],
                    // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    // onChanged: (val){
                    //   setState(() => genderIn = val);
                    // },
                  ), SizedBox(
                    height: 8,
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          try {
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final personalInfoRef = databaseReference.child(
                                'users/' + uid + '/personal_info/');
                            personalInfoRef.update({
                              "firstname": firstname.toString(),
                              "lastname": lastname.toString()
                            });
                            final additionalInfoRef = databaseReference.child(
                                'users/' + uid + '/vitals/additional_info/');
                            additionalInfoRef.update(
                                {"birthday": birthDateInString});
                            final ppRef = databaseReference.child(
                                'users/' + uid + '/physical_parameters/');
                            ppRef.update({
                              "height": height.toString(),
                              "weight": weight.toString()
                            });
                            print("Edited Personal Info Successfully! " + uid);
                            Future.delayed(const Duration(milliseconds: 1000), () {
                              infoChanged newPI = new infoChanged(firstname, lastname, weight, height, birthDateInString);
                              print("POP HERE ==========");
                              Navigator.pop(context, newPI);
                            });
                          } catch (e) {
                            print("you got an error! $e");
                          }
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
}

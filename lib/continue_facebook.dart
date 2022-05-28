import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/patient_list/doctor/doctor_patient_list.dart';
import 'package:my_app/patient_list/support_system/suppsystem_patient_list.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';

import 'dialogs/policy_dialog.dart';
class continue_facebook extends StatefulWidget {

  @override
  _continue_facebookState createState() => _continue_facebookState();
}
final _formKey = GlobalKey<FormState>();
class _continue_facebookState extends State<continue_facebook> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  bool checkboxValue = false;
  String valueChooseUserStatus;
  List<String> listUserStatus = <String>[
    'Patient', 'Doctor', 'Family member / Caregiver'
  ];
  String valueChooseDoctorKind = "Cardiologist";
  List<String> listDoctorKind = <String>[
    'Cardiologist', 'Allergists/Immunologist',
    'Anesthesiologist', 'Colon and Rectal Surgeon',
    'Critical Care Medicine Specialist',
    'Dermatologist','Endocrinologist',
    'Emergency Medicine Specialist',
    'Family Physician','Gastroenterologist',
    'Geriatric Medicine Specialist',
    'Hematologist','Hospice and Palliative Medicine Specialist',
    'Infectious Disease Specialist',
    'Internist','Medical Geneticist',
    'Nephrologist','Neurologist','Obstetrician/Gynecologist',
    'Oncologist','Ophthalmologist','Osteopath','Otolaryngologist',
    'Pathologist','Pediatrician','Physiatrist','Plastic Surgeon','Podiatrist'
        'Preventive Medicine Specialist','Psychiatrist','Pulmonologist','Radiologist',
    'Rheumatologist','Urologist'
  ];
  bool isDoctor = false;

  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();
  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        color:Color(0xff757575),
        child: Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular(20),
                  topRight:Radius.circular(20),
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Before signing up with Facebook...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 8),
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
                        hintText: "I am a: *",
                      ),
                      isExpanded: true,
                      value: valueChooseUserStatus,
                      validator: (value) => value == null
                          ? 'Please fill in your user type' : null,
                      onChanged: (newValue){
                        setState(() {
                          valueChooseUserStatus = newValue;
                          print(valueChooseUserStatus);
                          if(valueChooseUserStatus == "Doctor"){
                            isDoctor = true;
                          }
                          else{
                            isDoctor = false;
                          }
                        });
                      },
                      items: listUserStatus.map((valueItem){
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem)
                        );
                      },
                      ).toList(),
                    ),
                    SizedBox(height: 8.0),
                    Visibility(
                      visible: isDoctor,
                      child: DropdownButtonFormField(
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
                          hintText: "My Specialization is: *",
                        ),
                        isExpanded: true,
                        value: valueChooseDoctorKind,
                        onChanged: (newValue){
                          setState(() {
                            valueChooseDoctorKind = newValue;
                            print(valueChooseDoctorKind);


                          });
                        },
                        items: listDoctorKind.map((valueItem2){
                          return DropdownMenuItem(
                              value: valueItem2,
                              child: Text(valueItem2)
                          );
                        },
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    FormField<bool>(
                      builder: (state) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                    value: checkboxValue,
                                    onChanged: (bool b) {
                                      setState(() {
                                        checkboxValue = b;
                                      });
                                    }),
                                Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(text: "I have read and accept the "),
                                          TextSpan(
                                            text: 'Terms of Service \n',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return PolicyDialog(
                                                        mdFileName: 'terms_and_conditions.md',
                                                      );
                                                    });
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                          ),
                                          TextSpan(text: "and "),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return PolicyDialog(
                                                        mdFileName: 'privacy_policy.md',
                                                      );
                                                    });
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                          ),
                                        ]
                                    )
                                )
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.errorText ?? '',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                              ),
                            )
                          ],
                        );
                      },
                      validator: (value) {
                        if (!checkboxValue) {
                          return 'You need to accept the Terms of Service and Privacy Policy.';
                        } else {
                          return null;
                        }
                      },
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
                          onPressed:() {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(

                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed:() async {

                            if(_formKey.currentState.validate()){
                              _auth.loginFacebook(valueChooseUserStatus, true);
                              if(valueChooseUserStatus == "Patient"){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => set_up()),
                                  );
                              }
                              else if(valueChooseUserStatus == 'Family member / Caregiver'){

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => PatientListSupportSystemView()),
                                );

                              }
                              else{

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => PatientList()),
                                );
                              }
                            }
                            // Navigator.pop(context);
                          },
                        )
                      ],
                    ),

                  ]
              )
          ),
        )

    );
  }


}
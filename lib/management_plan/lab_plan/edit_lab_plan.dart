import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_lab_request extends StatefulWidget {
  final List<Lab_Plan> thislist;
  final String userUID;
  final int index;
  edit_lab_request({this.thislist, this.userUID, this.index});
  @override
  _editLabRequestState createState() => _editLabRequestState();
}
final _formKey = GlobalKey<FormState>();
class _editLabRequestState extends State<edit_lab_request> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  List<Lab_Plan> labplan_list = new List<Lab_Plan>();

  String purpose = "";
  int frequency = 1;
  String type;
  String important_notes = "";
  String prescribedBy = "";
  DateTimeRange dateRange;
  DateTime now =  DateTime.now();
  List<String> listLabResult = <String>[
    '2D Echocardiogram', 'ALT&AST', 'Angiogram',
    'Bun&Creatinine', 'Chest X-ray', 'Complete Blood Count',
    'Electrocardiogram','Filtration Rate', 'Glomerular',
    'Lipid Profile', 'Lung Biopsy' 'MRI CT Scan', 'Prothrombin Time','Pleural Fluid Analysis', 'Serum Electrolytes',
    'Ultrasound', 'Urine Microalbumin', 'A1C Test',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        key: _formKey,
        color:Color(0xff757575),
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
                    'Edit Lab Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8.0),
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
                      hintText: "Laboratory Test:",
                    ),
                    isExpanded: true,
                    value: type,
                    onChanged: (newValue){
                      setState(() {
                        type = newValue;
                      });

                    },
                    items: listLabResult.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),


                  SizedBox(height: 8.0),

                  TextFormField(
                    maxLines: 6,
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
                      hintText: "Important Notes/Assessments",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => important_notes = val);
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
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            labplan_list = widget.thislist;
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            int index = ((labplan_list.length + 1) - (widget.index+1)) ;
                            final planRef = databaseReference.child('users/' + widget.userUID + '/management_plan/vitals_plan/' + index.toString());
                            planRef.update({
                              "purpose": purpose.toString(),
                              "type": type.toString(),
                              "important_notes": important_notes.toString(),
                              "prescribedBy": uid,
                              "dateCreated": "${now.month}/${now.day}/${now.year}"});
                            Vitals a = new Vitals();
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              index = widget.index;
                              labplan_list[index].type = type.toString();
                              labplan_list[index].important_notes = important_notes.toString();
                              labplan_list[index].prescribedBy = prescribedBy.toString();
                              labplan_list[index].dateCreated = now;
                              print("POP HERE ==========");
                              Lab_Plan newV = labplan_list[index];
                              Navigator.pop(context, newV);
                            });
                          } catch(e) {
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
  void getVitals() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readVitals = databaseReference.child('users/' + userUID + '/management_plan/lab_plan/');
    readVitals.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labplan_list.add(Lab_Plan.fromJson(jsonString));
      });
    });
  }
}
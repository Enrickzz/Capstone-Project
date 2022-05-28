import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  final int index;
  final String userID;
  edit_medication_prescription({this.thislist,this.index, this.userID});
  @override
  _editMedicationPrescriptionState createState() => _editMedicationPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _editMedicationPrescriptionState extends State<edit_medication_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateTime prescriptionDate;
  bool isDateSelected= false;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  String generic_name = "";
  String branded_name = "";
  String startdate = "";
  String enddate = "";
  double dosage = 0;
  String intake_time = "";
  String special_instruction = "";
  String prescription_unit = "mL";
  int count = 0;
  List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  String valueChooseInterval;
  List<String> listItemSymptoms = <String>[
    '1', '2', '3','4'
  ];
  double _currentSliderValue = 1;
  List <bool> isSelected = [true, false, false, false, false];
  int quantity = 1;

  DateTimeRange dateRange;

  String getFrom(){
    if(dateRange == null){
      return 'From';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.start);

    }
  }

  String getUntil(){
    if(dateRange == null){
      return 'Until';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.end);

    }
  }

  Future pickDateRange(BuildContext context) async{
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours:24 * 3)),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if(newDateRange == null) return;

    setState(() => {
      dateRange = newDateRange,

      startdate = "${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}",
      enddate = "${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}",

    });
    print("date Range " + dateRange.toString());
  }
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
                    'Edit Medication Prescription',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
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
                      hintText: "Generic Name",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Generic Name' : null,
                    onChanged: (val){
                      setState(() => generic_name = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
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
                      hintText: "Brand Name",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Brand Name' : null,
                    onChanged: (val){
                      setState(() => branded_name = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // controller: unitValue,
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
                            hintText: "Dosage",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Dosage' : null,
                          onChanged: (val){
                            dosage = double.parse(val);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ToggleButtons(
                        isSelected: isSelected,
                        highlightColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('mL')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Mg')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('g')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Ug')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Iu')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                              } else {
                                isSelected[index] = false;
                              }
                            }

                            if(newIndex == 0){
                              prescription_unit = "mL";
                              print(prescription_unit);
                            }
                            if(newIndex == 1){
                              prescription_unit = "Mg";
                              print(prescription_unit);
                            }
                            if(newIndex == 2){
                              prescription_unit = "g";
                              print(prescription_unit);
                            }
                            if(newIndex == 3){
                              prescription_unit = "Ug";
                              print(prescription_unit);
                            }
                            if(newIndex == 4){
                              prescription_unit = "Iu";
                              print(prescription_unit);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Take how many times a day?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("1"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("2"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("3"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: quantity,
                                onChanged: (value){
                                  setState(() {
                                    this.quantity = value;
                                  });
                                },
                              ),
                              Text("4"),
                            ],
                          ),
                          SizedBox(width: 3)
                        ],
                      )
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(0.0),
                  //   child: Container(
                  //     padding: EdgeInsets.only(left: 16, right: 16),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey, width: 1),
                  //         borderRadius: BorderRadius.circular(15)
                  //     ),
                  //     child: DropdownButton(
                  //       dropdownColor: Colors.white,
                  //       hint: Text("Take how many times a day? "),
                  //       icon: Icon(Icons.arrow_drop_down),
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 14
                  //       ),
                  //       iconSize: 36,
                  //       isExpanded: true,
                  //       underline: SizedBox(),
                  //       value: valueChooseInterval,
                  //       onChanged: (newValue){
                  //         setState(() {
                  //           valueChooseInterval = newValue;
                  //         });
                  //       },
                  //
                  //       items: listItemSymptoms.map((valueItem){
                  //         return DropdownMenuItem(
                  //           value: valueItem,
                  //           child: Text(valueItem),
                  //         );
                  //       },
                  //       ).toList(),
                  //
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDateRange(context).then((value){
                            if(value != null && value != prescriptionDate){
                              setState(() {
                                print("set state value " + value.toString());
                                prescriptionDate = value;
                                isDateSelected = true;
                                startDate.text = startdate + "\r";
                              });

                            }
                          }),

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
                                hintText: getFrom(),
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
                      SizedBox(width: 8.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDateRange(context).then((value){
                            if(value != null && value != prescriptionDate){
                              setState(() {
                                prescriptionDate = value;
                                isDateSelected = true;
                                endDate.text = enddate + "\r";
                              });

                            }
                          }),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: endDate,
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
                                hintText: getUntil(),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF666666),
                                  size: defaultIconSize,
                                ),
                              ),
                              validator: (val) => val.isEmpty ? 'Select End Date' : null,
                              onChanged: (val){

                                print(endDate);
                                setState((){
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
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
                      hintText: "Special Instructions",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Special Instructions' : null,
                    onChanged: (val){
                      setState(() => special_instruction = val);
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
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            prescription_list = widget.thislist;
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            int index = ((prescription_list.length + 1) - (widget.index+1)) ;
                            final prescriptionRef = databaseReference.child('users/' + widget.userID + '/management_plan/medication_prescription_list/' + index.toString());
                            prescriptionRef.update({
                              "generic_name": generic_name.toString(),
                              "branded_name": branded_name.toString(),
                              "dosage": dosage.toString(),
                              "startDate": startdate.toString(),
                              "endDate": enddate.toString(),
                              "intake_time": quantity.toString(),
                              "special_instruction": special_instruction,
                              "medical_prescription_unit": prescription_unit,
                              "prescribedBy": uid});
                            print("Edited Medication Prescription Successfully! " + widget.userID + " $index");
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              index = widget.index;
                              prescription_list[index].generic_name = generic_name.toString();
                              prescription_list[index].branded_name = branded_name.toString();
                              prescription_list[index].dosage = dosage;
                              prescription_list[index].startdate = format.parse(startdate);
                              prescription_list[index].enddate = format.parse(enddate);
                              prescription_list[index].intake_time = quantity.toString();
                              prescription_list[index].special_instruction = special_instruction;
                              prescription_list[index].prescription_unit = prescription_unit;
                              prescription_list[index].prescribedBy = uid;

                              print("POP HERE ==========");
                              Medication_Prescription newMP = prescription_list[index];
                              Navigator.pop(context, newMP);
                            });


                            // Future.delayed(const Duration(milliseconds: 1000), (){
                            //   print("MEDICATION LENGTH: " + prescription_list.length.toString());
                            //   prescription_list.add(new Medication_Prescription(generic_name: generic_name, branded_name: branded_name,dosage: dosage, startdate: format.parse(startdate), enddate: format.parse(enddate), intake_time: quantity.toString(), special_instruction: special_instruction, prescription_unit: prescription_unit, prescribedBy: uid));
                            //   for(var i=0;i<prescription_list.length/2;i++){
                            //     var temp = prescription_list[i];
                            //     prescription_list[i] = prescription_list[prescription_list.length-1-i];
                            //     prescription_list[prescription_list.length-1-i] = temp;
                            //   }
                            //   print("POP HERE ==========");
                            //   Navigator.pop(context, [prescription_list, 1]);
                            // });

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
  void getMedicalPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/vitals/health_records/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prescription_list.add(Medication_Prescription.fromJson(jsonString));
      });
    });
  }
}
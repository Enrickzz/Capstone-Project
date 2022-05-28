import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
class edit_supplement_prescription extends StatefulWidget {
  final List<Supplement_Prescription> thislist;
  final int index;
  edit_supplement_prescription({this.thislist, this.index});
  @override
  _editSupplementPrescriptionState createState() => _editSupplementPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _editSupplementPrescriptionState extends State<edit_supplement_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateTime prescriptionDate;
  bool isDateSelected= false;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  String supplement_name = "";
  // String generic_name = "";
  // String branded_name = "";
  // String startdate = "";
  // String enddate = "";
  String intake_time = "";
  double supp_dosage = 0;
  String special_instruction = "";
  String prescription_unit = "";
  int count = 0;
  List<Supplement_Prescription> supplement_list = [];
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

    // setState(() => {
    //   dateRange = newDateRange,
    //   startdate = "${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}",
    //   enddate = "${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}",
    //
    // });
    // print("date Range " + dateRange.toString());
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
                    'Edit Supplements or Other Medicines',
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
                      hintText: "Supplement/Medicine name",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Supplement/Medicine name' : null,
                    onChanged: (val){
                      setState(() => supplement_name = val);
                    },
                  ),
                  // SizedBox(height: 8.0),
                  // TextFormField(
                  //   showCursor: true,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide(
                  //         width:0,
                  //         style: BorderStyle.none,
                  //       ),
                  //     ),
                  //     filled: true,
                  //     fillColor: Color(0xFFF2F3F5),
                  //     hintStyle: TextStyle(
                  //         color: Color(0xFF666666),
                  //         fontFamily: defaultFontFamily,
                  //         fontSize: defaultFontSize),
                  //     hintText: "Brand Name",
                  //   ),
                  //   validator: (val) => val.isEmpty ? 'Enter Brand Name' : null,
                  //   onChanged: (val){
                  //     setState(() => branded_name = val);
                  //   },
                  // ),
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
                            supp_dosage = double.parse(val);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ToggleButtons(
                        isSelected: isSelected,
                        borderRadius: BorderRadius.circular(10),
                        highlightColor: Colors.blue,
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
                          SizedBox(width: 16)
                        ],
                      )
                    ],
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
                            supplement_list = widget.thislist;
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            int index = ((supplement_list.length + 1) - (widget.index+1));
                            final prescriptionRef = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/' + index.toString());
                            DateTime prse = DateTime.parse(widget.thislist[widget.index].dateCreated.toString());
                            print(prse.toString() + " << this date");
                            prescriptionRef.update({"supplement_name": supplement_name.toString(),
                              "intake_time": quantity.toString(),
                              "supp_dosage": supp_dosage.toString(),
                              "medical_prescription_unit": prescription_unit,
                              "dateCreated": DateFormat('MM/dd/yyyy').format(prse)
                            });
                            print("Edited Supplement Prescription Successfully! " + uid);

                            Future.delayed(const Duration(milliseconds: 1000), (){
                              index = widget.index;
                              DateTime prse = DateTime.parse(widget.thislist[widget.index].dateCreated.toString());
                              print(prse.toString() + " << this date");
                              supplement_list[index].supplement_name = supplement_name;
                              supplement_list[index].intake_time =  quantity.toString();
                              supplement_list[index].dosage = supp_dosage;
                              supplement_list[index].prescription_unit = prescription_unit;

                              print("POP HERE ==========");

                              Navigator.pop(context, supplement_list[index]);
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
  void getSupplementPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsupplement = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        supplement_list.add(Supplement_Prescription.fromJson(jsonString));
      });
      for(var i=0;i<supplement_list.length/2;i++){
        var temp = supplement_list[i];
        supplement_list[i] = supplement_list[supplement_list.length-1-i];
        supplement_list[supplement_list.length-1-i] = temp;
      }
    });
  }
}
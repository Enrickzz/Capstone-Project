
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'lab_results.dart';
import 'medication.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_lab_results extends StatefulWidget {
  @override
  _addLabResultState createState() => _addLabResultState();
}
final _formKey = GlobalKey<FormState>();
class _addLabResultState extends State<add_lab_results> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  String thisURL;
  String lab_result_name = '';
  String lab_result_date = (new DateTime.now()).toString();
  DateTime labResultDate;
  String lab_result_note = '';
  String lab_result_time;
  String other_name = "";
  bool isDateSelected= false;
  int count = 1;
  List<Lab_Result> labResult_list = new List<Lab_Result>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List<FirebaseFile> trythis =[];

  //added by borj
  String valueChooseLabResult;
  List<String> listLabResult = <String>[
     '2D Echocardiogram', 'ALT&AST', 'Angiogram',
    'Bun&Creatinine', 'Chest X-ray', 'Complete Blood Count',
    'Electrocardiogram','Filtration Rate', 'Glomerular',
    'Lipid Profile', 'Lung Biopsy' 'MRI CT Scan', 'Prothrombin Time','Pleural Fluid Analysis', 'Serum Electrolytes',
    'Ultrasound', 'Urine Microalbumin', 'A1C Test',
     'Others'
  ];

  bool ptCheck = false;
  bool serumElectrolytesCheck = false;
  bool cbcCheck = false;
  bool bunCreaCheck = false;
  bool lipidProfileCheck = false;

  bool otherLabResultCheck = false;





  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    final Storage storage = Storage();
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
                    'Add Laboratory Result',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        hint: Text("Select Lab Result: "),
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                        iconSize: 36,
                        isExpanded: true,
                        underline: SizedBox(),
                        value: valueChooseLabResult,
                        onChanged: (newValue){
                          setState(() {
                            valueChooseLabResult = newValue;

                            if(valueChooseLabResult == 'Prothrombin Time'){
                              otherLabResultCheck = false;
                              ptCheck = true;
                             serumElectrolytesCheck = false;
                             cbcCheck = false;
                             bunCreaCheck = false;
                             lipidProfileCheck = false;
                            }
                            else if(valueChooseLabResult == 'Serum Electrolytes'){
                              otherLabResultCheck = false;
                              ptCheck = false;
                              serumElectrolytesCheck = true;
                              cbcCheck = false;
                              bunCreaCheck = false;
                              lipidProfileCheck = false;
                            }
                            else if(valueChooseLabResult == 'Complete Blood Count'){
                              otherLabResultCheck = false;
                              ptCheck = false;
                              serumElectrolytesCheck = false;
                              cbcCheck = true;
                              bunCreaCheck = false;
                              lipidProfileCheck = false;
                            }
                            else if(valueChooseLabResult == 'Bun&Creatinine'){
                              otherLabResultCheck = false;
                              ptCheck = false;
                              serumElectrolytesCheck = false;
                              cbcCheck = false;
                              bunCreaCheck = true;
                              lipidProfileCheck = false;
                            }

                            else if(valueChooseLabResult == 'Lipid Profile'){
                              otherLabResultCheck = false;
                              ptCheck = false;
                              serumElectrolytesCheck = false;
                              cbcCheck = false;
                              bunCreaCheck = false;
                              lipidProfileCheck = true;
                            }
                            else if(valueChooseLabResult == 'Others'){
                              otherLabResultCheck = true;
                              ptCheck = false;
                              serumElectrolytesCheck = false;
                              cbcCheck = false;
                              bunCreaCheck = false;
                              lipidProfileCheck = false;
                            }
                            else{
                              otherLabResultCheck = false;
                              ptCheck = false;
                              serumElectrolytesCheck = false;
                              cbcCheck = false;
                              bunCreaCheck = false;
                              lipidProfileCheck = false;
                            }
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
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Visibility(
                    visible: otherLabResultCheck,
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
                        hintText: "Name of Lab Result",
                      ),
                      validator: (val) => val.isEmpty ? 'Enter Name of Lab Result' : null,
                      onChanged: (val){
                        other_name = val;
                        // setState(() => lab_result_name = val);
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Visibility(
                    visible: ptCheck,
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
                        hintText: "International Normal Ratio",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: serumElectrolytesCheck,
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
                        hintText: "Potassium (mmol/L)",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: cbcCheck,
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
                        hintText: "Hemoglobin (Hb)",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: bunCreaCheck,
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
                        hintText: "BUN mg/dL",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: bunCreaCheck,
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
                        hintText: "Creatinine mg/dL",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: lipidProfileCheck,
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
                        hintText: "LDL Cholesterol mg/dL",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
                  ),
                  Visibility(
                    visible: lipidProfileCheck,
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
                        hintText: "HDL Cholesterol mg/dL",
                      ),
                      onChanged: (val){
                        setState(() => lab_result_note = val);
                      },
                    ),
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
                      hintText: "Note for Lab Result",
                    ),
                    onChanged: (val){
                      setState(() => lab_result_note = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100)
                      ).then((value){
                        if(value != null && value != labResultDate){
                          setState(() {
                            labResultDate = value;
                            isDateSelected = true;
                            lab_result_date = "${labResultDate.month}/${labResultDate.day}/${labResultDate.year}";
                          });
                          dateValue.text = lab_result_date + "\r";
                        }
                      });

                      final initialTime = TimeOfDay(hour:12, minute: 0);
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: TimeOfDay.now().hour,
                            minute: (TimeOfDay.now().minute - TimeOfDay.now().minute % 10 + 10)
                                .toInt()),
                      ).then((value){
                        if(value != null && value != time){
                          setState(() {
                            time = value;
                            final hours = time.hour.toString().padLeft(2,'0');
                            final min = time.minute.toString().padLeft(2,'0');
                            lab_result_time = "$hours:$min";
                            dateValue.text += "$hours:$min";
                            print("data value " + dateValue.text);
                          });
                        }
                      });
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
                          hintText: "Date and Time",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Date and Time' : null,
                        onChanged: (val){

                          print(dateValue);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 18.0),
                  GestureDetector(
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          // type: FileType.custom,
                          // allowedExtensions: ['jpg', 'png'],
                        );
                        if(result == null) return;
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final path = result.files.single.path;
                        final User user = auth.currentUser;
                        final uid = user.uid;
                        var fileName = result.files.single.name;
                        print("path" + path);
                        print("fileName " + fileName);
                        fileName = uid + fileName + "_lab_result" + "counter";
                        storage.uploadFile(path,fileName).then((value) => print("Upload Done"));

                        setState(() {
                          downloadUrl("5P4oNXb7KSYb87OA4Y1E1bYHhX82Get shit Done.jpg_lab_resultcounter");
                          //print("THIS IS THE LINK = " + thisURL);
                          listAll("path");
                          Navigator.pop(context);
                        });
                      }
                  ),
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
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readLabResult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list');
                            readLabResult.once().then((DataSnapshot datasnapshot) {
                              // String temp1 = datasnapshot.value.toString();
                              // print("temp1 " + temp1);
                              // List<String> temp = temp1.split(',');
                              // Lab_Result labResult;
                              if(datasnapshot.value == null){
                                if(valueChooseLabResult == "Others"){
                                  valueChooseLabResult = other_name;
                                }
                                final labResultRef = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/' + count.toString());
                                labResultRef.set({"labResult_name": valueChooseLabResult.toString() ,"labResult_note": lab_result_note.toString() , "labResult_date": lab_result_date.toString(), "labResult_time": lab_result_time.toString()});
                                print("Added Lab Result Successfully! " + uid);
                              }
                              else{

                                getLabResult();
                                // String tempLabResultName = "";
                                // String tempLabResultDate;
                                // String tempLabResultTime;
                                // String tempLabResultNote = "";
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //   switch(i%4){
                                //     case 0:
                                //       {
                                //         tempLabResultDate = splitFull.last;
                                //
                                //       }
                                //       break;
                                //     case 1:
                                //       {
                                //         tempLabResultName = splitFull.last;
                                //
                                //       }
                                //       break;
                                //     case 2:
                                //       {
                                //         tempLabResultNote = splitFull.last;
                                //       }
                                //       break;
                                //     case 3:
                                //       {
                                //         tempLabResultTime = splitFull.last;
                                //         labResult = new Lab_Result(labResult_name: tempLabResultName,labResult_note: tempLabResultNote, labResult_date: format.parse(tempLabResultDate), labResult_time: timeformat.parse(tempLabResultTime));
                                //         labResult_list.add(labResult);
                                //       }
                                //       break;
                                //
                                //   }
                                //   print("lab result list length " + labResult_list.length.toString());
                                //
                                // }
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = labResult_list.length;
                                  print(labResult_list.toString());
                                  print("count " + count.toString());
                                  if(valueChooseLabResult == "Others"){
                                    valueChooseLabResult = other_name;
                                  }
                                  final labResultRef = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/' + count.toString());
                                  labResultRef.set({"labResult_name": valueChooseLabResult.toString(),"labResult_note": lab_result_note.toString(), "labResult_date": lab_result_date.toString(), "labResult_time": lab_result_time.toString()});
                                  print("Added Lab Result Successfully! " + uid);
                                });

                              }

                            });


                            Future.delayed(const Duration(milliseconds: 1000), (){
                              if(valueChooseLabResult == "Others"){
                                valueChooseLabResult = other_name;
                              }
                              print("LAB RESULT LENGTH: " + labResult_list.length.toString());
                              labResult_list.add(new Lab_Result(labResult_name: valueChooseLabResult.toString(), labResult_date: format.parse(lab_result_date)));
                              for(var i=0;i<labResult_list.length/2;i++){
                                var temp = labResult_list[i];
                                labResult_list[i] = labResult_list[labResult_list.length-1-i];
                                labResult_list[labResult_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, labResult_list);
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
   Future <List<String>>_getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }

   Future<List<FirebaseFile>> listAll (String path) async {
    final ref = FirebaseStorage.instance.ref('test/');
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
    return urls
        .asMap()
        .map((index, url){
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name:name, url: url);
      trythis.add(file);
      print("This file " + file.url);
      return MapEntry(index, file);
    })
        .values
        .toList();

  }



  Future <String> downloadUrl(String imagename) async{
    final ref = FirebaseStorage.instance.ref('test/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }
  void getLabResult() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readlabresult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/');
    readlabresult.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labResult_list.add(Lab_Result.fromJson(jsonString));
      });
    });
  }

}
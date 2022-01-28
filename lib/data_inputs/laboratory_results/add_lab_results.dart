
import 'dart:convert';
import 'dart:async';
import 'dart:io';
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
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'lab_results_patient_view.dart';
import '../medicine_intake/medication_patient_view.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class add_lab_results extends StatefulWidget {
  final List<FirebaseFile> files;
  add_lab_results({Key key, this.files});
  @override
  _addLabResultState createState() => _addLabResultState();
}
final _formKey = GlobalKey<FormState>();
class _addLabResultState extends State<add_lab_results> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  var path;
  User user;
  var uid, fileName;
  File file = new File("path");
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
  String thisIMG="";
  //added by borj
  String valueChooseLabResult;
  String cacheFile="";
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
  bool pic = false;
  bool otherLabResultCheck = false;
  String international_normal_ratio=" ";
  String potassium=" ";
  String hemoglobin_hb=" ";
  String Bun_mgDl=" ";
  String creatinine_mgDl=" ";
  String ldl=" ";
  String hdl=" ";

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState(){
    initNotif();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // trythis.clear();
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
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
                      hintText: "Select Laboratory Result:",
                    ),
                    isExpanded: true,
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
                  Visibility(visible: otherLabResultCheck, child: SizedBox(height: 8.0)),

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
                  Visibility(visible: ptCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: ptCheck,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                        setState(() => international_normal_ratio = val);
                      },
                    ),
                  ),
                  Visibility(visible: serumElectrolytesCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: serumElectrolytesCheck,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                        setState(() => potassium = val);
                      },
                    ),
                  ),
                  Visibility(visible: cbcCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: cbcCheck,
                    child: TextFormField(

                      keyboardType: TextInputType.number,
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
                        setState(() => hemoglobin_hb = val);
                      },
                    ),
                  ),
                  Visibility(visible: bunCreaCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: bunCreaCheck,
                    child: TextFormField(

                      keyboardType: TextInputType.number,
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
                        setState(() => Bun_mgDl = val);
                      },
                    ),
                  ),
                  Visibility(visible: bunCreaCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: bunCreaCheck,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                        setState(() => creatinine_mgDl = val);
                      },
                    ),
                  ),
                  Visibility(visible: lipidProfileCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: lipidProfileCheck,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                        setState(() => ldl = val);
                      },
                    ),
                  ),
                  Visibility(visible: lipidProfileCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: lipidProfileCheck,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
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
                        setState(() => hdl = val);
                      },
                    ),
                  ),

                  SizedBox(height: 8.0),
                  TextFormField(

                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
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
                        firstDate: new DateTime.now().subtract(Duration(days: 30)),
                        lastDate: new DateTime.now(),
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
                  Visibility(visible: pic, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: pic,
                    child: Container(
                      child: Image.file(file),
                      height:250,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.black
                      ),

                    )
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.white,
                        height: 60.0,
                        color: Colors.cyan,
                        onPressed: () async{
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            // type: FileType.custom,
                            // allowedExtensions: ['jpg', 'png'],
                          );
                          if(result == null) return;
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final path = result.files.single.path;
                          user = auth.currentUser;
                          uid = user.uid;
                          fileName = result.files.single.name;
                          file = File(path);
                          print("DIRS this");
                          print(path);
                          PlatformFile thisfile = result.files.first;
                          cacheFile = thisfile.path;
                          Future.delayed(const Duration(milliseconds: 1000), (){
                            setState(() {
                              print("CACHE FILE\n" + thisfile.path +"\n"+file.path);
                              pic = true;
                            });
                          });

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.camera_alt_rounded, color: Colors.white,),
                            ),
                            Text('UPLOAD', )
                          ],
                        ),
                      ),
                    ],
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
                                labResultRef.set({"labResult_name": valueChooseLabResult.toString() ,
                                  "labResult_note": lab_result_note.toString(),
                                  "labResult_date": lab_result_date.toString(),
                                  "labResult_time": lab_result_time.toString(),
                                  "international_normal_ratio": international_normal_ratio,
                                  "potassium": potassium, "hemoglobin_hb": hemoglobin_hb,
                                  "Bun_mgDl": Bun_mgDl, "creatinine_mgDl": creatinine_mgDl,
                                  "ldl": ldl,
                                  "hdl": hdl, "imgRef": fileName.toString()});
                                Lab_Result newlab= new Lab_Result(
                                  labResult_name: valueChooseLabResult.toString()
                                  ,labResult_note: lab_result_note.toString()
                                  ,labResult_date: format.parse(lab_result_date), labResult_time: timeformat.parse(lab_result_time),
                                international_normal_ratio: international_normal_ratio, potassium: potassium, hemoglobin_hb: hemoglobin_hb, Bun_mgDl: Bun_mgDl, creatinine_mgDl: creatinine_mgDl,
                                ldl: ldl,hdl: hdl, imgRef: fileName.toString());

                                print("Added Lab Result Successfully! " + uid);
                              }
                              else{
                                getLabResult();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = labResult_list.length;
                                  print(labResult_list.toString());
                                  print("count " + count.toString());
                                  if(valueChooseLabResult == "Others"){
                                    valueChooseLabResult = other_name;
                                  }
                                  final labResultRef = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/' + count.toString());
                                  labResultRef.set({"labResult_name": valueChooseLabResult.toString() ,
                                    "labResult_note": lab_result_note.toString(),
                                    "labResult_date": lab_result_date.toString(),
                                    "labResult_time": lab_result_time.toString(),
                                    "international_normal_ratio": international_normal_ratio,
                                    "potassium": potassium, "hemoglobin_hb": hemoglobin_hb,
                                    "Bun_mgDl": Bun_mgDl, "creatinine_mgDl": creatinine_mgDl,
                                    "ldl": ldl,
                                    "hdl": hdl, "imgRef": fileName.toString()});
                                  print("Added Lab Result Successfully! " + uid);
                                });

                              }

                            });


                            Future.delayed(const Duration(milliseconds: 1000), (){
                              if(valueChooseLabResult == "Others"){
                                valueChooseLabResult = other_name;
                              }
                              print("LAB RESULT LENGTH: " + labResult_list.length.toString());
                              //labResult_list.add(new Lab_Result(labResult_name: valueChooseLabResult.toString(), labResult_date: format.parse(lab_result_date)));
                              labResult_list.add(new Lab_Result(labResult_name: lab_result_name,
                                  labResult_note:lab_result_note,
                                  labResult_date:format.parse(lab_result_date),
                                  labResult_time:timeformat.parse(lab_result_time),
                                  international_normal_ratio: international_normal_ratio.toString(),
                                  potassium: potassium.toString(),
                                  hemoglobin_hb: hemoglobin_hb.toString(),
                                  Bun_mgDl: Bun_mgDl,
                                  creatinine_mgDl: creatinine_mgDl,
                                  ldl:ldl,
                                  hdl:hdl,
                                  imgRef: fileName.toString()
                              )
                              );
                              for(var i=0;i<labResult_list.length/2;i++){
                                var temp = labResult_list[i];
                                labResult_list[i] = labResult_list[labResult_list.length-1-i];
                                labResult_list[labResult_list.length-1-i] = temp;
                              }
                              // RECOMMENDATION N NOTIFS
                              if(hemoglobin_hb != " " && valueChooseLabResult == "Complete Blood Count"){
                                if(double.parse(hemoglobin_hb.toString()) < 12){
                                  addtoRecommendation("We noticed that you have a low hemoglobin level. This is due to your body’s lack of protein which can cause Anemia. We recommend that you eat foods rich in protein. Click here to view recommended foods for you.",
                                      "Low Hemoglobin!",
                                      "3",
                                      "Food - Hemoglobin");
                                }
                              }
                              if(potassium != " " && valueChooseLabResult == "Serum Electrolytes"){
                                if(double.parse(potassium.toString()) <= 3){
                                  addtoRecommendation("We noticed that you have a low potassium level. We strongly advise you to seek immediate medical attention as soon as possible. For the meantime we recommend that you eat foods rich in Potassium . Click here to view recommended foods for you.",
                                      "Low Potassium!",
                                      "3",
                                      "Food - Potassium");
                                }
                              }
                              if(ldl != " " && valueChooseLabResult == "Lipid Profile"){
                                if(double.parse(ldl.toString()) <= 3){
                                  addtoRecommendation("We noticed that your LDL Cholesterol level is high which could be harmful for your body. We recommend that you eat food rich in Omega-3. Click here to view recommended foods for you.",
                                      "High Cholesterol!",
                                      "3",
                                      "Food - Cholesterol");
                                }
                              }
                              if(creatinine_mgDl != " " && valueChooseLabResult == "Bun&Creatinine"){
                                if(double.parse(creatinine_mgDl.toString()) > 1.2){
                                  final readAddinf = databaseReference.child("users/"+thisuser.uid+"/vitals/additional_info");
                                  readAddinf.once().then((DataSnapshot snapshot) {
                                    Additional_Info userInfo = Additional_Info.fromJson(jsonDecode(jsonEncode(snapshot.value)));
                                    bool check = false;
                                    for(var i = 0; i < userInfo.disease.length; i++){
                                      if(userInfo.disease[i] == "Chronic Kidney Disease") check == true;
                                    }
                                    for(var i = 0; i < userInfo.other_disease.length; i++){
                                      if(userInfo.other_disease[i] == "Chronic Kidney Disease") check == true;
                                    }
                                    if(check == true){
                                      addtoRecommendation("We noticed that your Creatinine level is unusually high and you do not have Chronic Kidney Disease as a listed ailment. We recommend that you consult with a Nephrologist as soon as possible.",
                                          "Creatinine Level is High!",
                                          "3",
                                          "None");
                                    }
                                  });
                                }
                              }

                              if(fileName != null){
                                FirebaseStorage.instance.ref('test/' + uid +"/"+fileName).putFile(file).then((p0) {

                                });
                              }
                              Future.delayed(const Duration(milliseconds: 1200), (){
                                Lab_Result newlab= new Lab_Result(
                                    labResult_name: valueChooseLabResult.toString()
                                    ,labResult_note: lab_result_note.toString()
                                    ,labResult_date: format.parse(lab_result_date), labResult_time: timeformat.parse(lab_result_time),
                                    international_normal_ratio: international_normal_ratio, potassium: potassium, hemoglobin_hb: hemoglobin_hb, Bun_mgDl: Bun_mgDl, creatinine_mgDl: creatinine_mgDl,
                                    ldl: ldl,hdl: hdl, imgRef: fileName.toString());

                                Navigator.pop(context, newlab);
                              });

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

  void addtoRecommendation(String message, String title, String priority, String redirect){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }
    });
  }
   Future <List<String>>_getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }

   Future<List<FirebaseFile>> listAll (String path) async {
     final User user = auth.currentUser;
     final uid = user.uid;
    final ref = FirebaseStorage.instance.ref('test/' + uid + "/");
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    // print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
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
    final User user = auth.currentUser;
    final uid = user.uid;
    final ref = FirebaseStorage.instance.ref('test/' +uid +'/$imagename');
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
  void getNotifs() {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }


}
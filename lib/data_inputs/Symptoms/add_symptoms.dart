
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/checkbox_state.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

import '../../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_symptoms extends StatefulWidget {
  final List<Symptom> thislist;
  add_symptoms({this.thislist});
  @override
  _addSymptomsState createState() => _addSymptomsState();
}
final _formKey = GlobalKey<FormState>();
class _addSymptomsState extends State<add_symptoms> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String symptom_name;
  int intesity_lvl = 0;
  String symptom_felt = '';
  String symptom_date = (new DateTime.now()).toString();
  String other_name = "";
  DateTime symptomDate;
  String symptom_time;
  bool isDateSelected= false;
  int count = 1;
  List<Symptom> symptoms_list = new List<Symptom>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List<String> checkboxStatus = [];

  bool value = false;
  final notifications ={
    CheckBoxState(title: 'Morning'),
    CheckBoxState(title: 'Afternoon'),
    CheckBoxState(title: 'Evening')
  };

//for pinch zoom body image
  final double minScale = 1;
  final double maxScale = 1.5;
  final double minScalePain = 1;
  final double maxScalePain = 4;



  bool isSwitched = false;
  bool bodyIsSwitched = false;
  bool painIsSwitched = false;
  String valueChooseSymptom;
  String valueChooseGeneralArea;
  List<String> listItemSymptoms = <String>[
    'Bleedings', 'Chest Pain', 'Dizziness', 'Excess Phlegm',
    'Fatigue', 'Frequent Urination', 'Headaches',
    'Loss of Balance', 'Loss of Appetite', 'Muscle Cramps',
   'Nausea', 'Numbness',   'Pain', 'Palpitations',
    'Seizures', 'Shortness of Breath', 'Skin Coloration',
    'Swollen Limbs','Swollen Muscles',
    'Vomiting', 'Wheezing', 'Yellowish Eyes', 'Others'
  ];

  List<String> listItemGeneralAreas = <String>[
    'Abdominal', 'Acromial','Antecubital',
    'Axillary', 'Brachial', 'Buccal',
    'Carpal', 'Cephalic', 'Cervical',
    'Coxal','Crural (leg)','Deltoid',
    'Digital', 'Femoral','Fibular',
    'Gluetal','Inguinal','Lumbar',
    'Nasal', 'Occipital', 'Orbital',
    'Oval','Patellar','Pelvic',
    'Popliteal', 'Pubic','Sacral',
    'Scapular', 'Sternal', 'Sural',
    'Tarsal','Thoracic','Umbilical',
    'Vertebral'
  ];

  bool otherSymptomsCheck = false;

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");

  User user;
  var uid, fileName;
  // File file;

  String dropdownValue = 'Select Symptom';

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState(){
    initNotif();

    symptoms_list.clear();
    super.initState();
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
              'Add Symptom',
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
                hintText: "Select Symptom:",
              ),
              isExpanded: true,
              value: valueChooseSymptom,
              onChanged: (newValue){
                setState(() {
                  valueChooseSymptom = newValue;

                  if(valueChooseSymptom == 'Others'){
                    otherSymptomsCheck = true;
                  }
                  else{
                    otherSymptomsCheck = false;
                  }
                });

              },
              items: listItemSymptoms.map((valueItem){
                return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                );
              },
              ).toList(),
            ),
            SizedBox(height: 8.0),
            Visibility(
              visible: otherSymptomsCheck,
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
                  hintText: "Other Symptom: ",
                ),
                validator: (val) => val.isEmpty ? 'Enter General area where Symptom is felt' : null,
                onChanged: (val){
                  other_name = val;
                  // setState(() => symptom_felt = val);

                },
              ),
            ),
            Visibility(
                visible: otherSymptomsCheck,
                child: SizedBox(height: 8.0)),
            TextFormField(
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
                hintText: "Intensity Level (1-10)",
              ),
              validator: (val) => val.isEmpty ? 'Enter Symptom Intensity Level' : null,
              onChanged: (val){
                setState(() => intesity_lvl = int.parse(val));
              },
            ),
            SizedBox(height: 8.0),
            SwitchListTile(
              title: Text('The Universal Pain Assessment Tool (UPAT)', style: TextStyle(fontSize: 14.0)),
              subtitle: Text('Show me the UPAT', style: TextStyle(fontSize: 12.0)),
              secondary: Icon(Icons.sentiment_neutral, size: 34.0, color: Colors.orange),
              controlAffinity: ListTileControlAffinity.trailing,
              value: painIsSwitched,
              onChanged: (value){
                setState(() {
                  painIsSwitched = value;

                });
              },
            ),
            Visibility(
              visible: painIsSwitched,
              child: Container(
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: minScalePain,
                  maxScale: maxScalePain,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/pain.png'
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                hintText: "General Area of Symptom:",
              ),
              isExpanded: true,
              value: valueChooseGeneralArea,
              onChanged: (newValue){
                setState(() {
                  valueChooseGeneralArea = newValue;
                });
              },
              items: listItemGeneralAreas.map((valueItem){
                return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem)
                );
              },
              ).toList(),
            ),
            SizedBox(height: 8.0),
            SwitchListTile(
              title: Text('Body General Areas', style: TextStyle(fontSize: 14.0)),
              subtitle: Text('Show me General Areas of the Body', style: TextStyle(fontSize: 12.0)),
              secondary: Icon(Icons.accessibility_new_rounded, size: 34.0, color: Colors.blue),
              controlAffinity: ListTileControlAffinity.trailing,
              value: bodyIsSwitched,
              onChanged: (value){
                setState(() {
                  bodyIsSwitched = value;

                });
              },
            ),
            Visibility(
              visible: bodyIsSwitched,
              child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: minScale,
                  maxScale: maxScale,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/body.PNG'
                      ),
                    ),
                  ),
              ),
            ),
            SizedBox(height: 8.0),
            SwitchListTile(
                title: Text('Recurring Symptom', style: TextStyle(fontSize: 14.0)),
                subtitle: Text('This symptom is recurring', style: TextStyle(fontSize: 12.0)),
                secondary: Icon(Icons.device_thermostat, size: 34.0, color: Colors.red),
                controlAffinity: ListTileControlAffinity.trailing,
                value: isSwitched,
                onChanged: (value){
                  setState(() {
                    isSwitched = value;
                  });
                },
            ),
            SizedBox(height: 8.0),
            ...notifications.map(buildSingleCheckbox).toList(),
            Visibility(
              visible: isSwitched,
              child: SizedBox(
                height: 24,
              ),
            ),
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
                  hintText: "What situation triggers your symptom?",
                ),
                validator: (val) => val.isEmpty ? 'Enter Syptom Trigger' : null,
                onChanged: (val){
                  symptom_felt = val;
                  // setState(() => symptom_felt = val);

                },
              ),
            ),
            Visibility(
              visible: isSwitched,
              child: SizedBox(
                height: 8,
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
            // GestureDetector(
            //     child: Text(
            //       'Upload',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     onTap: () async {
            //       final result = await FilePicker.platform.pickFiles(
            //         allowMultiple: false,
            //         // type: FileType.custom,
            //         // allowedExtensions: ['jpg', 'png'],
            //       );
            //       if(result == null) return;
            //       final FirebaseAuth auth = FirebaseAuth.instance;
            //       final path = result.files.single.path;
            //       user = auth.currentUser;
            //       uid = user.uid;
            //       fileName = result.files.single.name;
            //       file = File(path);
            //       // final ref = FirebaseStorage.instance.ref('test/' + uid +"/"+fileName).putFile(file).then((p0) {
            //       //   setState(() {
            //       //     trythis.clear();
            //       //     listAll("path");
            //       //     Future.delayed(const Duration(milliseconds: 1000), (){
            //       //       Navigator.pop(context, trythis);
            //       //     });
            //       //   });
            //       // });
            //       // fileName = uid + fileName + "_lab_result" + "counter";
            //       //storage.uploadFile(path,fileName).then((value) => print("Upload Done"));
            //     }
            // ),
            GestureDetector(
              onTap: ()async{
                await showDatePicker(
                    context: context,
                  initialDate: new DateTime.now(),
                  firstDate: new DateTime.now().subtract(Duration(days: 30)),
                  lastDate: new DateTime.now(),
                ).then((value){
                  if(value != null && value != symptomDate){
                    setState(() {
                      symptomDate = value;
                      isDateSelected = true;
                      symptom_date = "${symptomDate.month}/${symptomDate.day}/${symptomDate.year}";
                    });
                    dateValue.text = symptom_date + "\r";
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
                      symptom_time = "$hours:$min";
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
                      final User user = auth.currentUser;
                      final uid = user.uid;
                      symptoms_list.clear();
                      final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
                      readsymptom.once().then((DataSnapshot datasnapshot) {
                        if(datasnapshot.value == null){
                          if(valueChooseSymptom == "Others"){
                            valueChooseSymptom = other_name;
                          }
                          final symptomRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + 1.toString());
                          symptomRef.set({"symptom_name": valueChooseSymptom.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": valueChooseGeneralArea.toString(), "symptom_date": symptom_date.toString(), "symptom_time": symptom_time.toString(), "symptom_isActive": "true","symptom_trigger": symptom_felt, "recurring": checkboxStatus, "imgRef": fileName.toString()});
                          print("Added Symptom Successfully! " + uid);

                        }
                        else{
                          symptoms_list.clear();
                          getSymptoms();
                          Future.delayed(const Duration(milliseconds: 2000), (){
                            downloadUrls();
                            Future.delayed(const Duration(milliseconds: 2000), (){
                              count = symptoms_list.length--;
                              print("count " + count.toString());
                              if(valueChooseSymptom == "Others"){
                                valueChooseSymptom = other_name;
                              }
                              final symptomRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + count.toString());
                              symptomRef.set({"symptom_name": valueChooseSymptom.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": valueChooseGeneralArea.toString(),
                                "symptom_date": symptom_date.toString(), "symptom_time": symptom_time.toString(), "symptom_isActive": "true", "symptom_trigger": symptom_felt,
                                "recurring": checkboxStatus, "imgRef": fileName.toString()});

                              print("Added Symptom Successfully! " + uid);
                            });
                          });
                        }
                      });
                      Future.delayed(const Duration(milliseconds: 1000), (){
                        if(valueChooseSymptom == "Others"){
                          valueChooseSymptom = other_name;
                        }
                        symptoms_list.add(new Symptom(symptomName: valueChooseSymptom.toString(), intensityLvl: intesity_lvl, symptomFelt: valueChooseGeneralArea,symptomDate: format.parse(symptom_date), symptomTime: timeformat.parse(symptom_time), symptomIsActive: true, recurring: checkboxStatus, symptomTrigger: symptom_felt, imgRef: fileName));
                        for(var i=0;i<symptoms_list.length/2;i++){
                          var temp = symptoms_list[i];
                          symptoms_list[i] = symptoms_list[symptoms_list.length-1-i];
                          symptoms_list[symptoms_list.length-1-i] = temp;
                        }
                        print("filename = " + fileName.toString());
                        if(fileName != null){
                          FirebaseStorage.instance.ref('test/' + uid +"/"+fileName).putFile(file).then((p0) {

                          });
                        }

                        Symptom a = new Symptom(symptomName: valueChooseSymptom.toString(), intensityLvl: intesity_lvl,
                            symptomFelt: valueChooseGeneralArea,symptomDate: format.parse(symptom_date),
                            symptomTime: timeformat.parse(symptom_time), symptomIsActive: true,
                            recurring: checkboxStatus, symptomTrigger: symptom_felt, imgRef: fileName);

                        if(valueChooseSymptom.toString() == "Dizziness"){
                          addtoRecommendation("We recommend that you closely monitor your dizziness symptom and seek immediate medical attention if the symptom manifests frequently. For the meantime please drink a glass of water and remain seated for a while.",
                              "Dizziness",
                              "3", uid);
                        }
                        if(valueChooseSymptom.toString() == "Excess Phlegm"){
                          addtoRecommendation("We recommend that you closely monitor your symptoms for the following days. If pinkish substance can be seen in your phlegm, please seek immediate medical attention. For the meantime please stay hydrated throughout the day and gargle with anti-bacterial oral medicines.",
                              "Excess Phlem",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Fatigue"){
                          addtoRecommendation("If the symptom has lasted for more than a week, please seek immediate medical attention as this could be a sign of the progression of your CVD condition. For the meantime remember to eat healthy foods and get 7-9 hours of sleep every night. Avoid conducting any strenuous activities as this could lead to the progression of this symptom.",
                              "Fatigue",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Loss of Balance"){
                          addtoRecommendation("We recommend that you monitor this symptom for the next couple of days and immediately seek medical attention if you feel unwell. This can be a sign of the progression of your CVD condition. For the meantime please drink a glass of water and remain seated for a while. Avoid going up elevated areas and ask for assistance when moving around.",
                              "Loss of Balance",
                              "2", uid);
                        }

                        if(valueChooseSymptom.toString() == "Loss of Appetite"){
                          addtoRecommendation("This may be caused by certain side effects from medicines. If you continue to lose your appetite for the next 3 days, please seek immediate medical attention. For the meantime to compensate for the lack of food intake, please drink more fluids and hydrate yourself. Try to consume food even at small amounts. Click here for a list of recommended meals to compensate for your lack of food intake.",
                              "Loss of Appetite",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Loss of Appetite"){
                          addtoRecommendation("This may be caused by certain side effects from medicines. If you continue to lose your appetite for the next 3 days, please seek immediate medical attention. For the meantime to compensate for the lack of food intake, please drink more fluids and hydrate yourself. Try to consume food even at small amounts. Click here for a list of recommended meals to compensate for your lack of food intake.",
                              "Loss of Appetite",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Muscle Cramps"){
                          addtoRecommendation("We recommend that you closely monitor your symptom, if the pain is unbearable or if you feel unwell about it please seek immediate medical attention. For the meantime please hydrate yourself by drinking a glass of water and rest your body at a comfortable lying position.",
                              "Muscle Cramps",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Numbness"){
                          addtoRecommendation("We recommend you to closely monitor this symptom and seek immediate medical attention if you feel unwell about it.",
                              "Numbness",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Nausea"){
                          addtoRecommendation("This can be a sign of the progression of your CVD condition. Please seek immediate medical attention to address this symptom. For the meantime please drink a glass of water and remain seated for a while. We recommend that you monitor your blood pressure as long as the symptom persists and drink a glass of water every now and then.",
                              "Nausea",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Palpitations"){
                          addtoRecommendation("We recommend you to closely monitor this symptom and record all future events of palpitations. If you feel unwell please do not hesitate to seek immediate medical attention. For the meantime please relax yourself and perform deep breathing exercises as you listen to some soothing music.",
                              "Palpitations",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Seizures" && intesity_lvl > 7){
                          addtoRecommendation("We recommend that you record all instances of seizures in the future and if you feel unwell please do not hesitate to seek immediate medical attention. During a seizure please remember that it is best to stay in a left or right lying position and remove any obstacles around the patient.",
                              "Seizures",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Swollen Limbs" || valueChooseSymptom.toString() == "Swollen Muscle" ){
                          addtoRecommendation("We recommend that you closely monitor this symptom. This can be a sign of the progression of your heart condition and must be attended to by your doctor. For the meantime Rest and elevate the painful area. If you feel unwell or the pain becomes unbearable, please do not hesitate to seek immediate medical attention or advice.",
                              "Swollen",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Vomiting"){
                          addtoRecommendation("Frequent vomiting can be a sign of high blood pressure which should not be ignored. We strongly advise you to record your blood pressure and seek medical attention if vomiting persists. For the meantime please keep yourself hydrated and Ease yourself back into your regular diet with small amounts of bland foods. Click here to see recommended foods",
                              "Vomiting",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Wheezing"){
                          addtoRecommendation("We recommend that you closely monitor this symptom for the next few days. If you feel unwell please do not hesitate to seek immediate medical attention. For the meantime, drinking small amounts of warm fluids can relax the airway and loosen up sticky mucus in your throat.",
                              "Wheezing",
                              "2", uid);
                        }

                        if(valueChooseSymptom.toString() == "Chest Pain" && intesity_lvl > 7){
                          print("ADDING NOW");
                          final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                          readConnections.once().then((DataSnapshot snapshot2) {
                            print(snapshot2.value);
                            print("CONNECTION");
                            List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                            temp.forEach((jsonString) {
                              connections.add(Connection.fromJson(jsonString)) ;
                              Connection a = Connection.fromJson(jsonString);
                              print(a.doctor1);
                              addtoNotif(thisuser.firstname+" "+ thisuser.lastname + " is experiencing severe chest pains. He/she requires your immediate attention.",
                                  "Persistent Chest Pain",
                                  "4", a.doctor1);
                            });
                          });
                          addtoRecommendation("We have notified your doctors regarding your experiences of severe Chest Tightness. This can be a sign of a possible heart attack. Please seek immediate medical attention to address this symptom. If you have any prescriptions for Chest Pains please take them now. For the meantime you can sit, stay calm, and rest with the help of this soothing song.",
                              "Chest Pain",
                              "3", uid);

                        }
                        if(valueChooseSymptom.toString() == "Headaches" && intesity_lvl > 7){
                          print("ADDING NOW");
                          final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                          readConnections.once().then((DataSnapshot snapshot2) {
                            print(snapshot2.value);
                            print("CONNECTION");
                            List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                            temp.forEach((jsonString) {
                              connections.add(Connection.fromJson(jsonString)) ;
                              Connection a = Connection.fromJson(jsonString);
                              print(a.doctor1);
                              addtoNotif(thisuser.firstname+" "+ thisuser.lastname + " is experiencing severe headache. He/she requires your immediate attention.",
                                "Headaches",
                                "2", a.doctor1,);
                            });
                          });
                          addtoRecommendation("We have notified your doctors regarding your experiences of a severe headache. This can be a sign of the progression of your CVD condition. Please seek immediate medical attention to address this symptom. For the meantime you can sit, stay calm, and rest with the help of this soothing song.",
                              "Headache",
                              "2", uid);
                        }
                        if(valueChooseSymptom.toString() == "Pain" && intesity_lvl > 7){
                          print("ADDING NOW");
                          final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                          readConnections.once().then((DataSnapshot snapshot2) {
                            print(snapshot2.value);
                            print("CONNECTION");
                            List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                            temp.forEach((jsonString) {
                              connections.add(Connection.fromJson(jsonString)) ;
                              Connection a = Connection.fromJson(jsonString);
                              print(a.doctor1);
                              addtoNotif(thisuser.firstname+" "+ thisuser.lastname + " is experiencing severe pain. He/she requires your immediate attention.",
                                "Pain",
                                "3", a.doctor1,);
                            });
                          });
                          addtoRecommendation("We have notified your doctor and support system regarding the occurrence of severe pain. For the meantime Rest and elevate the painful area. Alternate between ice packs to reduce inflammation and heat to improve blood flow. Please seek immediate medical attention if the pain becomes unbearable and take pain relievers if necessary.",
                            "Pain",
                            "3", uid);
                        }
                        if(valueChooseSymptom.toString() == "Shortness of Breath" && intesity_lvl > 7){
                          print("ADDING NOW");
                          final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                          readConnections.once().then((DataSnapshot snapshot2) {
                            print(snapshot2.value);
                            print("CONNECTION");
                            List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                            temp.forEach((jsonString) {
                              connections.add(Connection.fromJson(jsonString)) ;
                              Connection a = Connection.fromJson(jsonString);
                              print(a.doctor1);
                              addtoNotif(thisuser.firstname+" "+ thisuser.lastname + " is experiencing shortness of breath. He/she may require your immediate attention.",
                                "Pain",
                                "1", a.doctor1,);
                            });
                          });
                        }
                        Future.delayed(const Duration(milliseconds: 1000), (){
                          Symptom newsymp = new Symptom(symptomName: valueChooseSymptom.toString(), intensityLvl: intesity_lvl,
                              symptomFelt: valueChooseGeneralArea,symptomDate: format.parse(symptom_date),
                              symptomTime: timeformat.parse(symptom_time), symptomIsActive: true,
                              recurring: checkboxStatus, symptomTrigger: symptom_felt, imgRef: fileName);
                          print("SYMPTOMS UPDATE LENGTH = " + symptoms_list.length.toString());
                          Navigator.pop(context, newsymp);
                        });
                      });

                    } catch(e) {
                      print("you got an error! $e");
                    }

                  },
                )
              ],
            ),

          ]
        )
      )

    );
  }

  Widget buildSingleCheckbox(CheckBoxState checkbox) =>  Visibility(
    visible: isSwitched,
    child: SizedBox(
      height: 50,
      child: CheckboxListTile(
        activeColor: Colors.blue,
        value: checkbox.value,
        title: Text(
          checkbox.title,
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Text('I experience this symptom every ' + checkbox.title.toLowerCase(),
          style: TextStyle(fontSize: 12),
        ),
        onChanged: (value) => setState(() => {
          checkbox.value = value,
          if(checkbox.value){
            checkboxStatus.add(checkbox.title),
          }
          else{
            for(int i = 0; i < checkboxStatus.length; i++){
              if(checkboxStatus[i] == checkbox.title){
                checkboxStatus.removeAt(i)
              },
            },
          },
        }),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ),
  );




  String getText (String date){
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r$hours:$min";
  }

  void getSymptoms() {
    symptoms_list.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print(temp);
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          print("NO RECURRING");
          symptoms_list.add(Symptom.fromJson2(jsonString));
        }
        else{
          print("WITH RECURRING");
          symptoms_list.add(Symptom.fromJson(jsonString));
        }
        print("SYMPTOM LIST LENGTH");
        print(symptoms_list.length);
      });
    });
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < symptoms_list.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+symptoms_list[i].imgRef.toString());
      if(symptoms_list[i].imgRef.toString() != "null" ){
        downloadurl = await ref.getDownloadURL();
        symptoms_list[i].imgRef = downloadurl;
      }

      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
    });
    return downloadurl;
  }
  void addtoNotif(String message, String title, String priority,String uid){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs(uid);
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    String redirect = "";
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});

      }
    });
  }
  void addtoRecommendation(String message, String title, String priority, String uid){
    getRecomm(uid);
    final ref = databaseReference.child('users/' + uid + '/recommendations/');
    String redirect = "";
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        ref.set({"id": 0.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + recommList.length.toString());
        ref.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});

      }
    });
  }
  void getRecomm(String uid) {
    print("GET RECOM");
    recommList.clear();
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void getNotifs(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
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

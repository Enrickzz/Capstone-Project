
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
    'Bleedings', 'Chest Tightness', 'Dizziness', 'Excess Phlegm', 'Excess Sputum',
    'Fatigue', 'Frequent Urination', 'Headaches', 'Imbalance', 'Involuntary Muscle Contractions',
    'Itchy Skin', 'Loss of Balance', 'Loss of Appetite', 'Muscle Cramps',
    'Muscle Numbness', 'Muscle Pain', 'Nausea', 'Palpitations',
    'Seizures', 'Shortness of Breath', 'Skin Coloration',
    'Swollen Limbs','Swollen Muscles','Vertigo',
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
                    firstDate: new DateTime(1900),
                    lastDate: new DateTime(2100)
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
                    Navigator.pop(context, widget.thislist);
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
                      final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
                      readsymptom.once().then((DataSnapshot datasnapshot) {
                        // String temp1 = datasnapshot.value.toString();
                        // print("temp1 " + temp1);
                        // List<String> temp = temp1.split(',');
                        // Symptom symptom;
                        if(datasnapshot.value == null){
                          if(valueChooseSymptom == "Others"){
                            valueChooseSymptom = other_name;
                          }
                          final symptomRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + count.toString());
                          symptomRef.set({"symptom_name": valueChooseSymptom.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": valueChooseGeneralArea.toString(), "symptom_date": symptom_date.toString(), "symptom_time": symptom_time.toString(), "symptom_isActive": true,"symptom_trigger": symptom_felt, "recurring": checkboxStatus, "imgRef": fileName.toString()});
                          print("Added Symptom Successfully! " + uid);

                        }
                        else{
                          getSymptoms();
                          // int tempIntesityLvl = 0;
                          // String tempSymptomName = "";
                          // DateTime tempSymptomDate;
                          // DateTime tempSymptomTime;
                          // bool tempIsActive;
                          // String tempSymptomFelt = "";
                          // List<String> tempRecurring = [];
                          // for(var i = 0; i < temp.length; i++){
                          //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                          //   List<String> splitFull = full.split(" ");
                          //     switch(i%6){
                          //       case 0: {
                          //         print("2nd switch intensity lvl " + splitFull.last);
                          //         tempIntesityLvl = int.parse(splitFull.last);
                          //       }
                          //       break;
                          //       case 1: {
                          //         print("2nd switch symptom name " + splitFull.last);
                          //         tempSymptomName = splitFull.last;
                          //       }
                          //       break;
                          //       case 2: {
                          //         print("2nd switch symptom name " + splitFull.last);
                          //         tempSymptomDate = format.parse(splitFull.last);
                          //       }
                          //       break;
                          //       case 3: {
                          //         print("2nd switch symptom name " + splitFull.last);
                          //
                          //       }
                          //       break;
                          //       case 4: {
                          //         print("2nd switch isactive " + splitFull.last);
                          //         tempSymptomTime = timeformat.parse(splitFull.last);
                          //       }
                          //       break;
                          //       case 5: {
                          //         print("2nd switch symptom felt " + splitFull.last);
                          //         tempSymptomFelt = splitFull.last;
                          //         // symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: tempSymptomDate, symptom_time: tempSymptomTime, symptom_isActive: tempIsActive);
                          //         symptoms_list.add(symptom);
                          //       }
                          //       break;
                          //     }
                          //   print("symptom list length " + symptoms_list.length.toString());
                          // }
                          Future.delayed(const Duration(milliseconds: 1000), (){
                            count = symptoms_list.length--;
                            print("count " + count.toString());
                            if(valueChooseSymptom == "Others"){
                              valueChooseSymptom = other_name;
                            }
                            final symptomRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + count.toString());
                            symptomRef.set({"symptom_name": valueChooseSymptom.toString(), "intensity_lvl": intesity_lvl.toString(), "symptom_felt": valueChooseGeneralArea.toString(), "symptom_date": symptom_date.toString(), "symptom_time": symptom_time.toString(), "symptom_isActive": true, "symptom_trigger": symptom_felt, "recurring": checkboxStatus, "imgRef": fileName.toString()});
                            print("Added Symptom Successfully! " + uid);
                          });

                        }

                      });


                      Future.delayed(const Duration(milliseconds: 1000), (){
                        if(valueChooseSymptom == "Others"){
                          valueChooseSymptom = other_name;
                        }
                        print("SYMPTOMS LENGTH: " + symptoms_list.length.toString());
                        symptoms_list.add(new Symptom(symptomName: valueChooseSymptom.toString(), intensityLvl: intesity_lvl, symptomFelt: valueChooseGeneralArea,symptomDate: format.parse(symptom_date), symptomTime: timeformat.parse(symptom_time), symptomIsActive: true, recurring: checkboxStatus, symptomTrigger: symptom_felt, imgRef: fileName));
                        for(var i=0;i<symptoms_list.length/2;i++){
                          var temp = symptoms_list[i];
                          symptoms_list[i] = symptoms_list[symptoms_list.length-1-i];
                          symptoms_list[symptoms_list.length-1-i] = temp;
                        }
                        print("POP HERE ==========");
                        Navigator.pop(context, symptoms_list);
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
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          symptoms_list.add(Symptom.fromJson2(jsonString));
        }
        else{
          symptoms_list.add(Symptom.fromJson(jsonString));
        }

      });
    });
  }

}

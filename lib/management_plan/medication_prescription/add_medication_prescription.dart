import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  String userUID;
  add_medication_prescription({this.thislist, this.userUID});
  @override
  _addMedicationPrescriptionState createState() => _addMedicationPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addMedicationPrescriptionState extends State<add_medication_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateTime prescriptionDate;
  bool isDateSelected= false;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  DateTime now = DateTime.now();
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  String datecreated = "";
  String generic_name = "";
  String branded_name = "";
  String startdate = "";
  String enddate = "";
  double dosage = 0;
  String intake_time = "";
  String special_instruction = "";
  String reason_notification = "";
  String prescription_unit = "mL";
  int count = 1;
  List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  String valueChooseInterval;
  List<String> listItemSymptoms = <String>[
    '1', '2', '3','4'
  ];
  double _currentSliderValue = 1;
  List <bool> isSelected = [true, false, false, false, false];
  int quantity = 1;
  bool checkboxValue = false;

  DateTimeRange dateRange;
  String thisURL;

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");
  User user;
  var uid, fileName;


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
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users doctor = new Users();
  Users patient = new Users();
  bool notifier = true;
  @override
  void initState(){
    initNotif();
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
                    'Add Medication Prescription',
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
                  SizedBox(height: 8.0),
                  FormField<bool>(
                    builder: (state) {
                      return Visibility(
                        visible: notifier,
                        child: Column(
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
                                Text("Notify lead doctor"),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: checkboxValue,
                    child: Column(
                      children: [
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
                            hintText: "Reason for notifying",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter reason for notifying' : null,
                          onChanged: (val){
                            setState(() => reason_notification = val);
                          },
                        ),
                      ],
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
                            String doctorName = "";
                            /// DOCTOR
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            /// PATIENT
                            var userUID = widget.userUID;
                            datecreated = format.format(now);
                            final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
                            Users doctor = new Users();
                            readDoctor.once().then((DataSnapshot snapshot) {
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              doctorName = doctor.firstname + " " + doctor.lastname;
                            });
                            final readPrescription = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/');
                            readPrescription.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              Medication_Prescription prescription;
                              if(datasnapshot.value == null){
                                final prescriptionRef = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/' + count.toString());
                                prescriptionRef.set({"generic_name": generic_name.toString(),
                                  "branded_name": branded_name.toString(),
                                  "dosage": dosage.toString(),
                                  "startDate": startdate.toString(),
                                  "endDate": enddate.toString(),
                                  "intake_time": quantity.toString(),
                                  "special_instruction": special_instruction.toString(),
                                  "medical_prescription_unit": prescription_unit.toString(),
                                  "prescribedBy": uid.toString(), "datecreated": datecreated.toString(),
                                  "doctor_name": doctorName, "imgRef": fileName.toString()});
                                print("if Added Medication Prescription Successfully! " + userUID);
                              }
                              else{
                                prescription_list.clear();
                                getMedicalPrescription();
                                Future.delayed(const Duration(milliseconds: 2000), (){
                                  downloadUrls();
                                  Future.delayed(const Duration(milliseconds: 2000), (){
                                    count = prescription_list.length--;
                                    final prescriptionRef = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/' + count.toString());
                                    prescriptionRef.set({"generic_name": generic_name.toString(), "branded_name": branded_name.toString(),"dosage": dosage.toString(), "startDate": startdate.toString(), "endDate": enddate.toString(), "intake_time": quantity.toString(), "special_instruction": special_instruction.toString(), "medical_prescription_unit": prescription_unit.toString(), "prescribedBy": uid.toString(), "datecreated": datecreated.toString(), "doctor_name": doctorName, "imgRef": fileName.toString()});
                                    print("else Added Medication Prescription Successfully! " + userUID);
                                  });
                                });
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 3000), () async{
                              print("MEDICATION LENGTH: " + prescription_list.length.toString());
                              prescription_list.add(new Medication_Prescription(generic_name: generic_name, branded_name: branded_name,dosage: dosage, startdate: format.parse(startdate), enddate: format.parse(enddate), intake_time: quantity.toString(), special_instruction: special_instruction, prescription_unit: prescription_unit, prescribedBy: uid, datecreated: format.parse(datecreated), doctor_name: doctorName, imgRef: fileName));
                              for(var i=0;i<prescription_list.length/2;i++){
                                var temp = prescription_list[i];
                                prescription_list[i] = prescription_list[prescription_list.length-1-i];
                                prescription_list[prescription_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");


                              await getNotifs(widget.userUID).then((value) {
                                addtoNotif("Dr. "+doctor.lastname+ " has added something to your medication management plan. Click here to view your new Medication Prescription plan. " ,
                                    "Doctor Added to your Medication Plan!",
                                    "1",
                                    "Medication Plan",
                                    widget.userUID);
                              });

                              if(checkboxValue == true){
                                notifyLead(userUID, reason_notification, doctor.lastname, "Medication");
                              }

                              if(fileName != null){
                                String finalfName = generic_name+"-" + branded_name+startdate.replaceAll("/", "")+enddate.replaceAll("/", "");

                                FirebaseStorage.instance.ref('test/' + widget.userUID +"/"+finalfName).putFile(file).then((p0) async{
                                  await downloadUrl(finalfName).then((value) {
                                    final prescriptionRef = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/' + count.toString());
                                    prescriptionRef.update({"imgRef": thisURL});
                                    Future.delayed(const Duration(seconds: 1), (){
                                      Medication_Prescription newPres = new Medication_Prescription(generic_name: generic_name,
                                          branded_name: branded_name,dosage: dosage, startdate: format.parse(startdate),
                                          enddate: format.parse(enddate), intake_time: quantity.toString(), special_instruction: special_instruction,
                                          prescription_unit: prescription_unit, prescribedBy: uid, datecreated: format.parse(datecreated),
                                          doctor_name: doctorName, imgRef: thisURL);
                                      Navigator.pop(context, newPres);
                                    });
                                  });
                                });
                              }else{
                                Medication_Prescription newPres = new Medication_Prescription(generic_name: generic_name,
                                    branded_name: branded_name,dosage: dosage, startdate: format.parse(startdate),
                                    enddate: format.parse(enddate), intake_time: quantity.toString(), special_instruction: special_instruction,
                                    prescription_unit: prescription_unit, prescribedBy: uid, datecreated: format.parse(datecreated),
                                    doctor_name: doctorName, imgRef: "null");
                                Navigator.pop(context, newPres);
                              }

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
  void notifyLead(String userUID, String reasonNotification, String doctorLastName, String planType){
    final connections = databaseReference.child('users/' + userUID + '/personal_info/lead_doctor/' );
    connections.once().then((DataSnapshot snapConnections) async {
      String temp = jsonDecode(jsonEncode(snapConnections.value));
      String leadDoc = temp.toString();
      //ADD NOTIF LOGIC =
      await getNotifs(leadDoc).then((value) {
        addtoNotif("Dr. "+doctorLastName+ " has added something to your patient's $planType management plan. He notes: "+reasonNotification ,
            "Dr. "+ doctorLastName + " added to your patient's $planType Plan!",
            "1",
            "$planType Plan",
            leadDoc);
      });

    });
    //notifyLead(userUID, reason_notification, doctor.lastname, "Exer");
  }
  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
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
  Future<void> getNotifs(String passedUid) async {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = passedUid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
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
        doctor = Users.fromJson(temp);
      });
      final readPatient = databaseReference.child('users/' + widget.userUID + '/personal_info/');
      readPatient.once().then((DataSnapshot snapshotPatient) {
        Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
        patientTemp.forEach((key, jsonString) {
          patient = Users.fromJson(patientTemp);
        });
        Future.delayed(const Duration(milliseconds: 200), (){
          if(patient.leaddoctor == uid){
            setState(() {
              notifier = false;
            });
          }else notifier= true;
        });
      });
    });
  }
  void getMedicalPrescription() {
    var userUID = widget.userUID;
    final readprescription = databaseReference.child('users/' + userUID + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prescription_list.add(Medication_Prescription.fromJson(jsonString));
      });
    });
  }
  Future <String> downloadUrl(String imagename) async{
    final ref = FirebaseStorage.instance.ref('test/' +widget.userUID +'/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < prescription_list.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+prescription_list[i].imgRef.toString());
      if(prescription_list[i].imgRef.toString() != "null" ){
        downloadurl = await ref.getDownloadURL();
        prescription_list[i].imgRef = downloadurl;
      }

      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
    });
    return downloadurl;
  }
}
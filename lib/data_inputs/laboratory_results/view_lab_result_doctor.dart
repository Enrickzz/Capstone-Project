
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/models/users.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:full_screen_image/full_screen_image.dart';
class view_lab_result_doctor_view extends StatefulWidget {
  final Lab_Result lr;
  final String imgurl;
  view_lab_result_doctor_view({Key key, this.lr, this.imgurl});
  @override
  viewLabResultDoctorView createState() => viewLabResultDoctorView();
}
final _formKey = GlobalKey<FormState>();
class viewLabResultDoctorView extends State<view_lab_result_doctor_view> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  var path;
  User user;
  var uid, fileName;
  File file;
  String thisURL="";
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
  final ButtonStyle style =
  ElevatedButton.styleFrom(textStyle: const TextStyle(fontFamily:'Montserrat',fontSize: 20));
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
  String international_normal_ratio=" ";
  String potassium=" ";
  String hemoglobin_hb=" ";
  String Bun_mgDl=" ";
  String creatinine_mgDl=" ";
  String ldl=" ";
  String hdl=" ";
  String thisIMG="";
  @override
  void initState(){

    // print("SET STATE LAB");
    print(widget.lr);
    print(widget.imgurl);
    // downloadUrl( widget.lr.imgRef.toString());
    setPage(widget.lr.labResult_name);
    Future.delayed(const Duration(milliseconds: 1200), (){
      setState(() {
        print("SETSTATE LAB ");
        print(thisURL);
      });
    });
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
                    ''+widget.lr.labResult_name+ " " + widget.lr.labResult_date.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  FullScreenWidget(
                    child: Container(
                      child: (Image.network('' + widget.lr.imgRef) != null) ? Image.network('' +widget.lr.imgRef, loadingBuilder: (context, child, loadingProgress) =>
                      (loadingProgress == null) ? child : CircularProgressIndicator(),
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover), fit: BoxFit.cover, ) : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover),
                      height:190,
                      width: 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Lab Result Type: ",
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF363f93),
                    ),
                  ),
                  Text(widget.lr.labResult_name),
                  Visibility(visible: otherLabResultCheck, child: SizedBox(height: 8.0)),

                  Visibility(
                    visible: otherLabResultCheck,
                    child: Text(""+widget.lr.labResult_note),
                  ),
                  Visibility(visible: ptCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: ptCheck,
                    child: Text(""+widget.lr.potassium),
                  ),
                  Visibility(visible: serumElectrolytesCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: serumElectrolytesCheck,
                    child: Text(""+widget.lr.potassium.toString()),
                  ),
                  Visibility(visible: cbcCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: cbcCheck,
                    child: Text("Hemoglobin (Hb):\n"+widget.lr.hemoglobin_hb +" Hb"),
                  ),
                  Visibility(visible: bunCreaCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: bunCreaCheck,
                    child: Text(""+widget.lr.Bun_mgDl),
                  ),
                  Visibility(visible: bunCreaCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: bunCreaCheck,
                    child: Text(""+ widget.lr.Bun_mgDl),
                  ),
                  Visibility(visible: lipidProfileCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: lipidProfileCheck,
                    child: Text(""+widget.lr.ldl + "mg/dL"),
                  ),
                  Visibility(visible: lipidProfileCheck, child: SizedBox(height: 8.0)),
                  Visibility(
                    visible: lipidProfileCheck,
                    child: Text(""+widget.lr.hdl + "mg/dL"),
                  ),

                  SizedBox(height: 8.0),
                  Text("Note: ",
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF363f93),
                    ),
                  ),
                  Text(widget.lr.labResult_note),
                  Text("Date and Time: ",
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF363f93),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(""+ getDateFormatted(widget.lr.labResult_date.toString()) +"at "
                      + getTimeFormatted(widget.lr.labResult_time.toString())) ,
                  SizedBox(height: 18.0),
                  ElevatedButton(
                    style: style,
                    onPressed: () async{
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        //add more permission to request here.
                      ].request();
                      if(statuses[Permission.storage].isGranted){
                        var dir = await DownloadsPathProvider.downloadsDirectory;
                        if(dir != null){
                          String fname = widget.lr.imgRef;
                          fname = fname.replaceAll("https://firebasestorage.googleapis.com/v0/b/capstone-heart-disease.appspot.com/o/test%2FLT8LwM7cKiTht29miQUOpSy1Eyy2%2F", "");
                          fname = fname.substring(0,fname.indexOf("?"));
                          print("final");
                          print(fname);
                          String savename = fname;
                          String savePath = dir.path + "/$savename";
                          print(savePath);
                          //output:  /storage/emulated/0/Download/banner.png

                          try {
                            await Dio().download(
                                widget.lr.imgRef,
                                savePath,
                                onReceiveProgress: (received, total) {
                                });
                            print("File is saved to download folder.");
                          } on DioError catch (e) {
                            print(e.message);
                          }
                        }
                      }else{
                        print("No permission to read and write.");
                      }
                    },
                    child: const Text('Download'),
                  )

                ]
            )
        )
    );
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
      //print("This file " + file.url);
      return MapEntry(index, file);
    })
        .values
        .toList();

  }



  Future <String> downloadUrl(String imagename) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final ref = FirebaseStorage.instance.ref('test/' + uid + "/$imagename");
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
  String getDateFormatted (String date){
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  Future<List<FirebaseFile>> listOne (String path, String filename) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    print("UID = " + uid);
    final ref = FirebaseStorage.instance.ref('test/' + uid +"/"+filename);
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    //print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
    return urls
        .asMap()
        .map((index, url){
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name:name, url: url);
      trythis.add(file);
      print("This file " + file.url);
      thisIMG = file.url.toString();
      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  void setPage(String labresultname){
    if(labresultname == 'Prothrombin Time'){
      otherLabResultCheck = false;
      ptCheck = true;
      serumElectrolytesCheck = false;
      cbcCheck = false;
      bunCreaCheck = false;
      lipidProfileCheck = false;
    }
    else if(labresultname == 'Serum Electrolytes'){
      otherLabResultCheck = false;
      ptCheck = false;
      serumElectrolytesCheck = true;
      cbcCheck = false;
      bunCreaCheck = false;
      lipidProfileCheck = false;
    }
    else if(labresultname == 'Complete Blood Count'){
      otherLabResultCheck = false;
      ptCheck = false;
      serumElectrolytesCheck = false;
      cbcCheck = true;
      bunCreaCheck = false;
      lipidProfileCheck = false;
    }
    else if(labresultname == 'Bun&Creatinine'){
      otherLabResultCheck = false;
      ptCheck = false;
      serumElectrolytesCheck = false;
      cbcCheck = false;
      bunCreaCheck = true;
      lipidProfileCheck = false;
    }

    else if(labresultname == 'Lipid Profile'){
      otherLabResultCheck = false;
      ptCheck = false;
      serumElectrolytesCheck = false;
      cbcCheck = false;
      bunCreaCheck = false;
      lipidProfileCheck = true;
    }
    else if(labresultname == 'Others'){
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
  }
}
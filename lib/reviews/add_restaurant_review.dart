
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
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/widgets/rating.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class add_restaurant_review extends StatefulWidget {
  final List<FirebaseFile> files;
  add_restaurant_review({Key key, this.files});
  @override
  _create_postState createState() => _create_postState();
}
final _formKey = GlobalKey<FormState>();
class _create_postState extends State<add_restaurant_review> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  var path;
  User user;
  var uid, fileName;
  // File file;
  String thisURL;
  String title = '';
  String description = '';

  List<FirebaseFile> trythis =[];
  String thisIMG="";

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");

  //for rating
  int _rating = 0;
  bool isSwitched = false;



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
                    'Restaurant Review/Recommendation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 12,
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
                      hintText: "Description",
                    ),
                    onChanged: (val){
                      setState(() => description = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  SwitchListTile(
                    title: Text('Recommend', style: TextStyle(fontSize: 22.0)),
                    subtitle: Text('I would like to recommend this restaurant to other CVD patients.', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons.thumb_up_alt_sharp, size: 34.0, color: Colors.green),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isSwitched,
                    onChanged: (value){
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Rating", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                      SizedBox(width: 14,),
                      Rating((rating){
                        setState(() {
                          _rating = rating;
                        });

                      }),
                    ],

                  ),

                  SizedBox(
                    height: 44,
                    child: _rating != null && _rating >0
                        ? Text("I give this place a rating of $_rating star/s",
                        style: TextStyle(fontSize: 18))
                        :SizedBox.shrink(),

                  ),
                  SizedBox(height: 18.0),
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

                  // SizedBox(height: 18.0),
                  //
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     FlatButton(
                  //       textColor: Colors.white,
                  //       height: 60.0,
                  //       color: Colors.cyan,
                  //       onPressed: () async{
                  //         final result = await FilePicker.platform.pickFiles(
                  //           allowMultiple: false,
                  //           // type: FileType.custom,
                  //           // allowedExtensions: ['jpg', 'png'],
                  //         );
                  //         if(result == null) return;
                  //         final FirebaseAuth auth = FirebaseAuth.instance;
                  //         final path = result.files.single.path;
                  //         user = auth.currentUser;
                  //         uid = user.uid;
                  //         fileName = result.files.single.name;
                  //         file = File(path);
                  //         PlatformFile thisfile = result.files.first;
                  //         cacheFile = thisfile.path;
                  //         Future.delayed(const Duration(milliseconds: 1000), (){
                  //           setState(() {
                  //             print("CACHE FILE\n" + thisfile.path +"\n"+file.path);
                  //             pic = true;
                  //           });
                  //         });
                  //
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Icon(Icons.camera_alt_rounded, color: Colors.white,),
                  //           ),
                  //           Text('UPLOAD', )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                          'Post',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        onPressed:() {
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
    final ref = FirebaseStorage.instance.ref('test/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }


}
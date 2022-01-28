
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
import 'package:my_app/models/discussionModel.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class create_journal extends StatefulWidget {
  final List<FirebaseFile> files;
  String userUID;
  create_journal({Key key, this.files, this.userUID}): super(key: key);
  @override
  _create_postState createState() => _create_postState();
}
final _formKey = GlobalKey<FormState>();
class _create_postState extends State<create_journal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  User user;
  Users doctor = new Users();
  int count = 1;
  DateTime now =  DateTime.now();
  var uid, fileName;
  String thisURL;
  String title = '';
  String description = '';
  List<Discussion> discussion_list = new List<Discussion>();


  List<FirebaseFile> trythis =[];
  // String thisIMG="";

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");



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
                    'Create Journal Entry',
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
                      hintText: "Title",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Title' : null,
                    onChanged: (val){
                      title = val;
                      // setState(() => lab_result_name = val);
                    },
                  ),
                  SizedBox(height: 8.0),
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

                  SizedBox(height: 18.0),

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
                        // onPressed: (){
                        //   Navigator.pop(context);
                        // },
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            final readDiscussion = databaseReference.child('users/' + userUID + '/journal/');
                            final readCreator = databaseReference.child('users/' + uid + '/personal_info/');
                            String createdBy = "";
                            readCreator.once().then((DataSnapshot snapshot){
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              createdBy = doctor.firstname + " " + doctor.lastname;
                              readDiscussion.once().then((DataSnapshot datasnapshot) {
                                String temp1 = datasnapshot.value.toString();
                                print("temp1 " + temp1);
                                if(datasnapshot.value == null){
                                  final discussionRef = databaseReference.child('users/' + userUID + '/journal/' + count.toString());
                                  discussionRef.set({"title": title, "createdBy": createdBy,"discussionDate": "${now.month}/${now.day}/${now.year}", "discussionTime": "${now.hour}:${now.minute}", "discussionBody": description, "noOfReplies": 0.toString(), "imgRef": fileName});
                                  print("Added to Journal Entry Successfully! " + userUID);
                                }
                                else{
                                  getDiscussion();
                                  Future.delayed(const Duration(milliseconds: 1000), (){
                                    print(count);
                                    count = discussion_list.length--;
                                    final discussionRef = databaseReference.child('users/' + userUID + '/journal/' + count.toString());
                                    discussionRef.set({"title": title, "createdBy": createdBy,"discussionDate": "${now.month}/${now.day}/${now.year}", "discussionTime": "${now.hour}:${now.minute}", "discussionBody": description, "noOfReplies": 0.toString(), "imgRef": fileName});
                                    print("Added to Journal Entry Successfully! " + userUID);
                                  });

                                }

                              });
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              discussion_list.add(new Discussion(title: title, createdBy: createdBy, discussionDate: now, discussionTime: now, discussionBody: description, noOfReplies: 0, imgRef: fileName));
                              // for(var i=0;i<discussion_list.length/2;i++){
                              //   var temp = discussion_list[i];
                              //   discussion_list[i] = discussion_list[discussion_list.length-1-i];
                              //   discussion_list[discussion_list.length-1-i] = temp;
                              // }
                              print("POP HERE ==========");
                              Navigator.pop(context, [discussion_list, 1]);
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
  // Future <List<String>>_getDownloadLinks(List<Reference> refs) {
  //   return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  // }

  // Future<List<FirebaseFile>> listAll (String path) async {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final ref = FirebaseStorage.instance.ref('test/' + uid + "/");
  //   final result = await ref.listAll();
  //   final urls = await _getDownloadLinks(result.items);
  //   // print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
  //   return urls
  //       .asMap()
  //       .map((index, url){
  //     final ref = result.items[index];
  //     final name = ref.name;
  //     final file = FirebaseFile(ref: ref, name:name, url: url);
  //     trythis.add(file);
  //     print("This file " + file.url);
  //     return MapEntry(index, file);
  //   })
  //       .values
  //       .toList();
  //
  // }



  Future <String> downloadUrl(String imagename) async{
    final ref = FirebaseStorage.instance.ref('test/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }
  void getDiscussion() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readdiscussion = databaseReference.child('users/' + userUID + '/journal/');
    readdiscussion.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        discussion_list.add(Discussion.fromJson(jsonString));
      });
    });
  }

}






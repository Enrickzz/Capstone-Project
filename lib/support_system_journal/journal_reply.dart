
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


class reply_journal extends StatefulWidget {
  final List<FirebaseFile> files;
  String userUID;
  int index;
  reply_journal({Key key, this.files, this.userUID, this.index}): super(key: key);
  @override
  _reply_postState createState() => _reply_postState();
}
final _formKey = GlobalKey<FormState>();
class _reply_postState extends State<reply_journal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Discussion discussion = new Discussion();
  List<Replies> reply_list = new List<Replies>();
  Users doctor = new Users();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  String doctor_name = "";
  String specialty = "";
  DateTime now =  DateTime.now();
  DateTime date;
  DateTime time;
  String dateString = "";
  String timeString = "";
  String replyBody = '';
  int count = 1;

  var path;
  User user;
  var uid, fileName;
  // File file;
  String thisURL;
  List<FirebaseFile> trythis =[];
  String thisIMG="";
  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");

  @override
  Widget build(BuildContext context) {
    // trythis.clear();
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    final Storage storage = Storage();
    dateString = "${now.month}/${now.day}/${now.year}";
    timeString = "${now.hour}:${now.minute}";


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
                    'Write a Reply',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 16,
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
                      hintText: "Reply",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Reply' : null,
                    onChanged: (val){
                      setState(() => replyBody = val);
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
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            int index = widget.index;
                            print(index);
                            Replies reply = new Replies();
                            final readReply = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString() +'/replies/');
                            final readCreator = databaseReference.child('users/' + uid + '/personal_info/');
                            final readDiscussion = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString());
                            readCreator.once().then((DataSnapshot createsnapshot){
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(createsnapshot.value));
                              doctor = Users.fromJson(temp);
                              doctor_name = doctor.firstname + " " + doctor.lastname;
                              specialty = "Support System";
                              readReply.once().then((DataSnapshot replysnapshot) {
                                String temp1 = replysnapshot.value.toString();
                                print("temp1");
                                print(temp1);
                                if(replysnapshot.value == null){
                                  final replyRef = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString() + "/replies/" + count.toString());
                                  reply = new Replies(uid: uid, createdBy: doctor_name, specialty: specialty, replyDate: now, replyTime: now, replyBody: replyBody);
                                  replyRef.update(reply.toJson());
                                  readDiscussion.once().then((DataSnapshot discussionsnapshot) {
                                    Map<String, dynamic> temp2 = jsonDecode(jsonEncode(discussionsnapshot.value));
                                    discussion = Discussion.fromJson(temp2);
                                    readDiscussion.update({"noOfReplies": (discussion.noOfReplies+1).toString()});
                                    print("no of replies added 1 successfully");
                                  });
                                  // replyRef.set({"createdBy": doctor_name, "specialty": specialty, "replyDate": "${now.month}/${now.day}/${now.year}", "replyTime": "${now.hour}:${now.minute}", "replyBody": replyBody});
                                  print("Added Journal Entry Reply Successfully! " + userUID);
                                }
                                else{
                                  getReply();
                                  Future.delayed(const Duration(milliseconds: 1000), (){
                                    count = reply_list.length--;
                                    final replyRef = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString() +'/replies/' + count.toString());
                                    reply = new Replies(uid: uid, createdBy: doctor_name, specialty: specialty, replyDate: now, replyTime: now, replyBody: replyBody);
                                    replyRef.update(reply.toJson());
                                    readDiscussion.once().then((DataSnapshot discussionsnapshot) {
                                      Map<String, dynamic> temp2 = jsonDecode(jsonEncode(discussionsnapshot.value));
                                      discussion = Discussion.fromJson(temp2);
                                      readDiscussion.update({"noOfReplies": (discussion.noOfReplies+1).toString()});
                                      print("no of replies added 1 successfully");
                                    });
                                    print("Added Journal Entry Reply Successfully! " + userUID);
                                  });

                                }

                              });
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              reply_list.add(new Replies(createdBy: doctor_name, specialty: specialty, replyDate: now, replyTime: now, replyBody: replyBody));
                              // for(var i=0;i<reply_list.length/2;i++){
                              //   var temp = reply_list[i];
                              //   reply_list[i] = reply_list[reply_list.length-1-i];
                              //   reply_list[reply_list.length-1-i] = temp;
                              // }
                              print("POP HERE ==========");
                              Navigator.pop(context, [reply_list, 1]);
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

  void getReply() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    int index = widget.index;
    final readreply = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString() +'/replies/');
    readreply.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print("temp");
      print(temp);
      temp.forEach((jsonString) {
        reply_list.add(Replies.fromJson(jsonString));
      });
    });
  }

}
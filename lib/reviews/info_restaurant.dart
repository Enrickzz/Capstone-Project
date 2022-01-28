
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/models/GooglePlaces.dart';
import 'package:my_app/models/specific_info_places.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/reviews/specific_restaurant_reviews.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/widgets/rating.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class info_restaurant extends StatefulWidget {
  final List<FirebaseFile> files;
  info_restaurant({Key key, this.files, this.this_info, this.thisrating,this.type});
  final Results this_info;
  final double thisrating;
  final String type;
  @override
  _create_postState createState() => _create_postState();
}
final _formKey = GlobalKey<FormState>();
class _create_postState extends State<info_restaurant> {
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
  final double minScale = 1;
  final double maxScale = 1.5;

  SpecificInfo details= new SpecificInfo();
  bool isLoading = true;

  @override
  void initState(){
    getspecifics(widget.this_info.placeId);
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
                    widget.this_info.name,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  Container(
                    child: _displayMedia(widget.this_info.photos.photoReference),
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

                  ),
                  SizedBox(height: 8.0),
                  checkrating(widget.thisrating),

                  SizedBox(height: 8.0),
                  Row(

                    children: [
                      Icon(
                        Icons.location_on,
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          widget.this_info.formattedAddress,
                          style: TextStyle( fontSize: 14),
                        ),
                      ),


                    ],


                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [


                      Icon(
                        Icons.local_phone_outlined,
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(),
                        ): new Text(
                          details.result.formattedPhoneNumber,
                          style: TextStyle( fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 20.0),

                      Icon(
                        Icons.access_time_sharp,
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: isLoading
                            ?  Center(
                          child: CircularProgressIndicator(),
                        ): checkifnull(),
                      ),
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
                        child: _displayMedia(widget.this_info.photos.photoReference),
                        height:250,
                        width: 300,
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
                      Visibility(
                        visible: true,
                        child: FlatButton(
                          child: Text(
                            'View Reviews',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => restaurant_reviews(thisPlace: widget.this_info, type: widget.type)),
                            );
                          },
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),



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
  Widget _displayMedia(String media) {
    if(media == "photoref") {
      print("PHOTOREF ITO ");
      return Image.asset("assets/images/no-image.jpg");
    }
    else{
      return Image.network(media,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset("assets/images/no-image.jpg");
        },fit: BoxFit.cover,);
    }

  }

  Widget checkifnull(){
    if(details.result.openingHours != null){
      if(details.result.openingHours.periods[0] != null
      && details.result.openingHours.periods[0] != null){
        if(details.result.openingHours.periods[0].open != null && details.result.openingHours.periods[0].close != null){
          if(details.result.openingHours.periods[0].open.time != null && details.result.openingHours.periods[0].close.time != null){
            return Text(
              details.result.openingHours.periods[0].open.time.toString() + " - " +
                  details.result.openingHours.periods[0].close.time.toString(),
              style: TextStyle( fontSize: 14),
            );
          }
        }
      }
    }else{
      return Text("Not Listed");
    }
    return Text("Not Listed");
  }
  Widget checkrating(double thisrating) {
    String textRate="";
    String rating="";
    bool checker = true;
    if(thisrating == 0){
      textRate = "No reviews yet";
      rating = "";
      checker = false;
    }else{
      textRate = '(' +thisrating.toString() +')';
      rating = "Rating";
    }
    return Row(
      children: [
        Text(
          rating,
          style: TextStyle( fontSize: 14),
        ),
        SizedBox(width: 8.0),

        ratingWidget(checker, thisrating),
        Text(
          textRate,
          style: TextStyle( fontSize: 14),
        ),
      ],
    );
  }
  Widget ratingWidget(bool check, double thisrating){
    if(check == true){
      return RatingBar(
        initialRating: thisrating,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        ignoreGestures: true,
        itemSize: 12,
        onRatingUpdate: (rating) {
          print(rating);
        },
        ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.orange),
            half: Icon(
              Icons.star_half,
              color: Colors.orange,
            ),
            empty: Icon(
              Icons.star_outline,
              color: Colors.orange,
            )),
      );
    }else{
      return Text(
        "",
        style: TextStyle(color: Colors.black, fontSize: 12),
      );
    }
  }
  Future<SpecificInfo> getspecifics(String id) async{

    var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=AIzaSyBFsY_boEXrduN5Huw0f_eY88JDhWwiDrk"));
    details = SpecificInfo.fromJson(jsonDecode(response.body));

    print(details.result.placeId);
    print("===============\n" + widget.this_info.placeId);
    // print(details.result.openingHours.periods[0].open.time);
    // print(details.result.openingHours.periods[0].close.time);
    setState(() {
      isLoading = false;
    });
  }

}
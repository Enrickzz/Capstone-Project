import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class addImage extends StatefulWidget {
  final File img;
  addImage({this.img});
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<addImage> {

  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //based sa tutorial File? image; dapat https://www.youtube.com/watch?v=MSv38jO4EJk&t=339s 2:08
  File image;
  bool isUpdated = false;
  // var imagePermanent;
  // File image_path = "";
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemporary = File(image.path);
      // image permanent https://www.youtube.com/watch?v=MSv38jO4EJk&t=339s 6:39
      // imagePermanent = await saveImagePermanently(image.path);
      // image_path = File(image.path);
      setState(() {
        this.image = imageTemporary;
        isUpdated = true;
      });
      // setState(() =>  this.image = imageTemporary);
    } on PlatformException catch (e){
      print('Failed to pick image: $e');
    }

  }
  Future<File> saveImagePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }


  @override
  void initState(){
    super.initState();
    if(widget.img != null){
      image = widget.img;
    }
    // Future.delayed(const Duration(milliseconds: 1200), (){
    //   setState(() {
    //   });
    // });
  }



  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.amber.shade200,
    appBar: AppBar(
      iconTheme: IconThemeData(
          color: Colors.black
      ),
      title: const Text('Change Profile Picture', style: TextStyle(
          color: Colors.black
      )),
      centerTitle: true,
      backgroundColor: Colors.white,

    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Spacer(),
          image!= null
              ? ClipOval(
              child: Image.file(
                  image,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover
              )
          )
              : ClipOval(
                child: Image.asset("assets/images/blank_person.png",
                width: 160,
                height: 160,
                fit: BoxFit.cover
          ),
              ),
          const SizedBox(height: 24),
          Text(
            'Image Gallery',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          buildButton(
            title: 'Upload from Gallery',
            icon: Icons.image_outlined,
            onClicked: () => pickImage(),
          ),

          const SizedBox(height: 200),
          Visibility(
            visible: isUpdated,
            child: Container(
              child: ElevatedButton(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text('Done', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                onPressed: ()  {
                  final User user = auth.currentUser;
                  final uid = user.uid;
                  final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
                  readProfile.update({"pp_img": image.path});
                  Navigator.pop(context);

                  // print('signed out');
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LogIn()),
                  // );
                },
              ),
            ),
          ),



        ],
      ),


    ),

  );

  Widget buildButton({
    String title,
    IconData icon,
    VoidCallback onClicked,

}) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(fontSize: 20)
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
        onPressed: onClicked,
      );

}



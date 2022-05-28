import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/storage_service.dart';

class GridImages extends StatefulWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation<double> animation;

  const GridImages(
      {Key key,
        this.titleTxt: "",
        this.subTxt: "",
        this.animationController,
        this.animation, Map Function() onTap})
      : super(key: key);

  @override
  _GridImagesState createState() => _GridImagesState();
}

class _GridImagesState extends State<GridImages> {
  final List<PhotoItem> _items = [
    PhotoItem(
        "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
        "Stephan Seeber"),
    PhotoItem(
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
        "Liam Gant"),
  ];
  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        final Storage storage = Storage();
        return FadeTransition(

          opacity: widget.animation,
          child:
          Container(
            width: double.infinity,
            child: RaisedButton(
              child: new Text ("Select File"),
              // icon: Icons.attach_file,
              onPressed: () async{
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  // type: FileType.custom,
                  // allowedExtensions: ['jpg', 'png'],
                );
                if(result == null) return;
                final FirebaseAuth auth = FirebaseAuth.instance;
                final path = result.files.single.path;
                final User user = auth.currentUser;
                final uid = user.uid;
                var fileName = result.files.single.name;
                print("path" + path);
                print("fileName " + fileName);
                fileName = uid + "lab_result" + "counter";
                storage.uploadFile(path,fileName).then((value) => print("Upload Done"));
              },
            ),
          ),
        );
      },
    );
  }
}

class PhotoItem {
  final String image;
  final String name;
  PhotoItem(this.image, this.name);
}

Future<List<FirebaseFile>> listAll (String path) async {
  final ref = FirebaseStorage.instance.ref(path);
  final result = await ref.listAll();
  final urls = await _getDownloadLinks(result.items);

  return urls
      .asMap()
      .map((index, url){
        final ref = result.items[index];
        final name = ref.name;
        final file = FirebaseFile(ref: ref, name:name, url: url);
        return MapEntry(index, file);
      })
      .values
      .toList();
}

Future <List<String>>_getDownloadLinks(List<Reference> refs) {
  Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
}
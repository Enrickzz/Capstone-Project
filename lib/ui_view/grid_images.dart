import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';

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
        return FadeTransition(

          opacity: widget.animation,
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
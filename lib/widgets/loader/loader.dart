import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  final Color iconColor;
  final IconData icon;
  final String animationType;
  final String shape;
  final bool rotateIcon;

  Loader({ this.iconColor = Colors.black, this.icon = Icons.movie, this.animationType = "full_flip", this.shape = "square", this.rotateIcon = true});
  
  
  @override
  _LoaderState createState() => _LoaderState(this.iconColor, this.icon, this.animationType, this.shape, this.rotateIcon);
}

class _LoaderState extends State<Loader>
    with SingleTickerProviderStateMixin {
  
  AnimationController controller;
  Animation<double> rotationHorizontal;
  Animation<double> rotationVertical;
  Color iconColor;
  IconData icon;
  Widget loaderIconChild;
  String animationType;
  String shape;
  bool rotateIcon;

  _LoaderState(this.iconColor, this.icon, this.animationType, this.shape, this.rotateIcon);

  @override
  void initState() {
    super.initState();

    controller = createAnimationController(animationType);

    controller.addStatusListener((status){
      // Play animation backwards and forwards for full flip
      if (animationType == "full_flip") {
        if (status == AnimationStatus.completed) {
          setState(() {
            controller.repeat();
          });
        }
      }
      // play animation on repeat for half flip
      else if (animationType == "full_flip") {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            controller.forward();
          });
        }
        if (status == AnimationStatus.completed) {
          setState(() {
            controller.repeat();
          });
        }
      }
      // custom animation state 
      else {
        print("TODO not sure yet");
      }
    });

    controller.forward();
  }

  AnimationController createAnimationController([String type = 'full_flip']) {
    AnimationController animCtrl;

    switch(type) {
      case "half_flip":
        animCtrl = AnimationController(duration: const Duration(milliseconds: 4000), vsync: this);
        
        // Horizontal animation
        this.rotationHorizontal = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animCtrl,
            curve: Interval(0.0, 0.50, curve: Curves.linear)));

        // Vertical animation
        this.rotationVertical = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animCtrl,
            curve: Interval(0.50, 1.0, curve: Curves.linear)));
      break;
      case "full_flip":
      default:
        animCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
        
        this.rotationHorizontal = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animCtrl,
            curve: Interval(0.0, 0.50, curve: Curves.linear)));
        this.rotationVertical = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animCtrl,
            curve: Interval(0.50, 1.0, curve: Curves.linear)));
      break;
    }

    return animCtrl;
  }

  @override
  Widget build(BuildContext context) {
    if (animationType == "half_flip") {
      return buildHalfFlipper(context);
    } else {
      return buildFullFlipper(context);
    }
  }

  Widget buildHalfFlipper(BuildContext context) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          child: new Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.006)
              ..rotateX(sin(2*pi * rotationVertical.value))
              ..rotateY(sin(2*pi * rotationHorizontal.value)),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                shape: shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: shape == "circle" ? null : new BorderRadius.all(const Radius.circular(8.0)),
              ),
              width: 35.0,
              height: 35.0,
              child: rotateIcon == true ? new RotationTransition(
                turns: rotationHorizontal.value == 1.0 ? rotationVertical : rotationHorizontal,
                child: new Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 35.0,
                  ),
                ),
              ) : Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 35.0,
                ),
              )
            ),
          ),
        );
      },
    );
  }

  Widget buildFullFlipper(BuildContext context) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          child: new Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.006)
              ..rotateX((2* pi * rotationVertical.value))
              ..rotateY((2* pi * rotationHorizontal.value)),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                shape: shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: shape == "circle" ? null : new BorderRadius.all(const Radius.circular(8.0)),
              ),
              width: 35.0,
              height: 35.0,
              child: new Center(
                child: Icon(
                  icon, color: iconColor, size: 35.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
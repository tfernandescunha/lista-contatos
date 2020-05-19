import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  ContactImage(this.image, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: this.image != null
                  ? FileImage(File(this.image))
                  : AssetImage('images/person.png'))),
    );
  }
}

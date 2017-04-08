import 'package:flutter/material.dart';
import 'dart:io';

class RecipeStyle extends TextStyle {
}

class RecipeWidget extends StatelessWidget {
  String title;
  String imageUrl;
  String publisher;
  String publisherUrl;
  String recipeID;
  RecipeWidget(this.title, this.imageUrl,
      this.publisher, this.publisherUrl, this.recipeID);
  @override
  Widget build(BuildContext context) {

    Widget imageSection = new Container(
      child: new Column(
        children: [
          new Image.network(imageUrl,
            fit: BoxFit.fitHeight,
            width: 500.00
          ),
          new Container(
            child:
              new Row(
                children: [
                  new Text(
                    title,
                    style: new TextStyle(inherit: false,
                      color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ]
              ),
            color: Colors.black54,
            padding: new EdgeInsets.fromLTRB(2.0, 36.0, 2.0, 36.0),
            width: 500.00
          )
  ],
      ),
      padding: new EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0)
    );
    return imageSection;
    }
  }

class _RecipeTitle extends StatelessWidget {
  _RecipeTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: FractionalOffset.centerLeft,
      child: new Text(title)
    );
  }
}

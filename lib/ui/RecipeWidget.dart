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
    return new Container(
      child: new GridTile(
      child: new Image.network(imageUrl,
        fit: BoxFit.cover,
      ),
      footer: new GridTileBar(
        title: new _RecipeText(title),
        subtitle: new _RecipeText(publisher),
        backgroundColor: Colors.black45
      )
    ),
      width: 500.00,
      height: 400.00
    );
  }

  }


class _RecipeText extends StatelessWidget {
  _RecipeText(this.title);

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


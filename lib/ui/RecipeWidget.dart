import 'package:flutter/material.dart';

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
        height: 240.0,
        fit: BoxFit.fitWidth),
          new Container(
            child:
              new Row(
                children: [
                  new Text(
                    title,
                    style: new TextStyle(inherit: false, color: new Color(0xffffff))
                  )
                ]
              ),
            color: new Color.fromRGBO(2,2,2,0.8),
            padding: new EdgeInsets.fromLTRB(2.0, 12.0, 2.0, 12.0)
          )
  ],
      )
    );
    return imageSection;
    }
  }


}
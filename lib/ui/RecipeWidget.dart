import 'package:flutter/material.dart';
import 'package:eggfn/services/FavouriteService.dart' show FavouriteService;

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
        backgroundColor: Colors.black45,
        trailing: new _RecipeFavouriteIcon(recipeID),
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

class _RecipeFavouriteIcon extends StatefulWidget {
  String recipeid;
  _RecipeFavouriteIcon(this.recipeid);

  @override
  _FavouriteState createState() => new _FavouriteState(recipeid);
}

class _FavouriteState extends State<_RecipeFavouriteIcon> {
  FavouriteService favs = new FavouriteService();
  String recipeid;
  bool _isFavourite = false;
  _FavouriteState(this.recipeid);

  void _toggleFavourite() {
    setState(() {
      if (_isFavourite) {
        favs.deleteFavourite(recipeid);
        _isFavourite = false;
      } else {
        favs.addFavourite(recipeid);
        _isFavourite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData favIcon = _isFavourite ? Icons.star : Icons.star_border;
    return new Container(child: new Icon(favIcon),
    );

  }
}


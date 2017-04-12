import 'package:flutter/material.dart';
import 'package:eggfn/services/FavouriteService.dart' show FavouriteService;
import '../services/Recipe.dart' show Recipe;

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
        child:
        new RecipeImageWidget(imageUrl, recipeID, title, publisher),
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

class RecipeImageWidget extends StatelessWidget {
  String imageUrl;
  String recipeid;
  String title;
  String publisher;
  RecipeImageWidget(this.imageUrl, this.recipeid, this.title, this.publisher);
  void showRecipe(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(title)
        ),
        body: new SizedBox.expand(
          child: new Hero(
            tag: recipeid,
            child: new _RecipeDetailViewer(imageUrl, title),
          ),
        ),
      );
    }));
  }
  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
      onTap: () { showRecipe(context); },
      child: new Hero(
        tag: recipeid,
        child: new Image.network(imageUrl,
        fit: BoxFit.cover
        ),
    ));
    return image;
  }
}

class _RecipeDetailViewer extends StatefulWidget {
  String imageUrl;
  String title;
  _RecipeDetailViewer(this.imageUrl, this.title);

  @override
  _RecipeDetailState createState() => new _RecipeDetailState();
}

class _RecipeDetailState extends State<_RecipeDetailViewer> {
  // TODO (1) size recipe image / details.
  // TODO (2) add recipeingredients view.
  // TODO (3) add favouriteicon.
  // TODO (4) switch layout on orientation.
  @override
  Widget build(BuildContext context) {
    return new Container(
      child:
      new Hero(
          tag: widget.imageUrl,
          child:
    (
        new Image.network(widget.imageUrl,
          fit: BoxFit.fill,
        )
    )
      )
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
    return new Container(
        child: new IconButton(icon: new Icon(favIcon),
        onPressed: _toggleFavourite
    ),
    );
  }
}


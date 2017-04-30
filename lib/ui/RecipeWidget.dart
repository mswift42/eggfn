import 'package:flutter/material.dart';
import 'package:eggfn/services/FavouriteService.dart' show FavouriteService;
import 'package:eggfn/services/Recipe.dart' show Recipe;
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/services.dart' show UrlLauncher;

class RecipeStyle extends TextStyle {
  const RecipeStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.black,
    double letterSpacing,
    double height,
    String fontFamily,
  })
      : super(
            inherit: false,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            textBaseline: TextBaseline.alphabetic,
            letterSpacing: letterSpacing,
            height: height);
}

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  RecipeWidget(this.recipe);
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new GridTile(
            child: new RecipeImageWidget(recipe),
            footer: new GridTileBar(
              title: new _RecipeText(recipe.title),
              subtitle: new _RecipeText(recipe.publisher),
              backgroundColor: Colors.black45,
              trailing: new _RecipeFavouriteIcon(recipe.recipeID),
            )),
        width: 500.00,
        height: 400.00);
  }
}

class RecipeImageWidget extends StatelessWidget {
  final Recipe recipe;
  RecipeImageWidget(this.recipe);
  void showRecipe(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text(recipe.title)),
        body: new FittedBox(
          fit: BoxFit.contain,
          child: new Hero(
            tag: recipe.recipeID,
            child: new _RecipeDetailViewer(recipe),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = new GestureDetector(
        onTap: () {
          showRecipe(context);
        },
        child: new Hero(
          tag: recipe.recipeID,
          child: new Image.network(recipe.imageUrl, fit: BoxFit.cover),
        ));
    return image;
  }
}

class _RecipeDetailViewer extends StatefulWidget {
  final Recipe recipe;
  _RecipeDetailViewer(this.recipe);

  @override
  _RecipeDetailState createState() => new _RecipeDetailState();
}

class _RecipeDetailState extends State<_RecipeDetailViewer> {
  // TODO (4) switch layout on orientation.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double deviceWidth = size.width;
    final double deviceHeight = size.height;
    return new Container(
      constraints: new BoxConstraints(
        maxHeight: deviceWidth,
        maxWidth: deviceHeight,
      ),
      child: new Center(
        child: new Hero(
          tag: widget.recipe.imageUrl,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new _RecipeDetailImageView(widget.recipe.imageUrl, deviceHeight / 3.0),
                new _RecipeDetailBottomView(widget.recipe, deviceHeight / 1.5),
              ]),
        ),
      ),
    );
  }
}

class _RecipeDetailImageView extends StatelessWidget {
  final String imageUrl;
  final double height;

  _RecipeDetailImageView(this.imageUrl, this.height);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        height: height,
        child: new Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class _RecipeDetailBottomView extends StatelessWidget {
  final Recipe recipe;
  final double height;

  _RecipeDetailBottomView(this.recipe, this.height);
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 3,
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new _RecipeDetailPublisherView(recipe),
            new _RecipeIngredientsView(recipe.ingredients),
          ]),
    );
  }
}

class _RecipeDetailPublisherView extends StatelessWidget {
  final Recipe recipe;

  _RecipeDetailPublisherView(this.recipe);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new RaisedButton(
                onPressed: () => UrlLauncher.launch(recipe.publisherUrl),
                child: new Text(recipe.publisher,
                    style: Theme.of(context).textTheme.subhead),
                color: Theme.of(context).accentColor),
            new RaisedButton(
              onPressed: () => UrlLauncher.launch(recipe.sourceUrl),
              child: new Text("Go To Recipe",
                  style: Theme.of(context).textTheme.subhead),
              color: Theme.of(context).accentColor,
            ),
          ]),
    );
  }
}

class _RecipeIngredientsView extends StatelessWidget {
  _RecipeIngredientsView(this.ingredients);

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
      return new ListView(children:
              ingredients.map((i) => new _RecipeIngredientView(i)).toList(),
          itemExtent: 30.00,
      );
  }
}

class _RecipeIngredientView extends StatelessWidget {
  final String ingredient;

  _RecipeIngredientView(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.fromLTRB(22.0, 12.0, 22.0, 10.0),
      child: new Chip(
        label: new Text(
          ingredient,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
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
      child: new Text(title),
    );
  }
}

class _RecipeFavouriteIcon extends StatefulWidget {
  final String recipeid;
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
      child:
          new IconButton(icon: new Icon(favIcon), onPressed: _toggleFavourite),
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                UrlLauncher.launch(url);
              });
}

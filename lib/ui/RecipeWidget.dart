import 'package:flutter/material.dart';
import 'package:eggfn/services/FavouriteService.dart' show FavouriteService;
import 'package:eggfn/services/Recipe.dart' show Recipe;

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
  // TODO - use Material Card to display image / publisher / ingredients.
  final Recipe recipe;
  _RecipeDetailViewer(this.recipe);

  @override
  _RecipeDetailState createState() => new _RecipeDetailState();
}

class _RecipeDetailState extends State<_RecipeDetailViewer> {
  // TODO (1) size recipe image / details.
  // TODO (3) add favouriteicon.
  // TODO (4) switch layout on orientation.
  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints(
        maxWidth: 800.00,
        minWidth: 400.00,
        maxHeight: 1000.00,
        minHeight: 200.00,
      ),
      child: new Center(
        child: new Hero(
          tag: widget.recipe.imageUrl,
          child: new Card(
            color: Colors.white,
              child: new SizedBox(height: 800.00,
            child: new Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Container(
                    child: new SizedBox(height:400.00,
                    child: new Image.network(
                      widget.recipe.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
              ),
                  new Container(
                    child:
                        new _RecipeDetailPublisherView(widget.recipe.publisher),
                  ),
                  new Row(children: <Widget>[
                    new Expanded(
                      child: new Divider(height: 20.00),
                    ),
                  ]),
                  new _RecipeIngredientsView(widget.recipe.ingredients)
                ]),
        ),
        ),
      ),
      ),
      padding: new EdgeInsets.fromLTRB(42.0, 20.0, 42.0, 20.0),
    );
  }
}

class _RecipeDetailPublisherView extends StatelessWidget {
  final String publisher;

  _RecipeDetailPublisherView(this.publisher);
  @override
  Widget build(BuildContext context) {
    return new Text(publisher,
        style: new RecipeStyle(fontSize: 20.0, fontWeight: FontWeight.bold));
  }
}

class _RecipeIngredientsView extends StatelessWidget {
  _RecipeIngredientsView(this.ingredients);

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Wrap(
        children: ingredients.map((i) => new _RecipeIngredientView(i)).toList(),
      ),
    );
  }
}

class _RecipeIngredientView extends StatelessWidget {
  final String ingredient;

  _RecipeIngredientView(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          border: new Border.all(color: Theme.of(context).accentColor)),
      padding: new EdgeInsets.fromLTRB(22.0, 12.0, 22.0, 10.0),
      child: new Text(
        ingredient,
        style: new TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 22.0,
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

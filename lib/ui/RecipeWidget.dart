import 'package:flutter/material.dart';
import 'package:eggfn/services/FavouriteService.dart' show FavouriteService;
import 'package:eggfn/services/Recipe.dart' show Recipe;

class RecipeStyle extends TextStyle {
  const RecipeStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.white70,
    double letterSpacing,
    double height,
    String fontFamily,

  }) : super(
      inherit: false,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: letterSpacing,
      height: height
  );
}

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  RecipeWidget(this.recipe);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GridTile(
        child:
        new RecipeImageWidget(recipe),
        footer: new GridTileBar(
        title: new _RecipeText(recipe.title),
        subtitle: new _RecipeText(recipe.publisher),
        backgroundColor: Colors.black45,
        trailing: new _RecipeFavouriteIcon(recipe.recipeID),
      )
    ),
      width: 500.00,
      height: 400.00
    );
  }

}

class RecipeImageWidget extends StatelessWidget {
  final Recipe recipe;
  RecipeImageWidget(this.recipe);
  void showRecipe(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(recipe.title)
        ),
        body: new FittedBox(fit: BoxFit.cover,
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
      onTap: () { showRecipe(context); },
      child: new Hero(
        tag: recipe.recipeID,
        child: new Image.network(recipe.imageUrl,
        fit: BoxFit.cover
        ),
    ));
    return image;
  }
}

class _RecipeDetailViewer extends StatefulWidget {
  // TODO - use Material Card to display image / publisher / ingredients.
  Recipe recipe;
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
        alignment: FractionalOffset.center,
        child:
        new Hero(
          tag: widget.recipe.imageUrl,
          child: new Card(
            elevation: 1,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.network(widget.recipe.imageUrl,
                    fit: BoxFit.fill,

                  ),
                  new _RecipeIngredientsView(widget.recipe.ingredients)
                ]
            ),
          ),
        ),
        padding: new EdgeInsets.fromLTRB(42.0, 20.0, 42.0, 20.0),
        constraints: new BoxConstraints(
          minHeight: 400.0,
          maxHeight: 600.0,
          minWidth: 400.0,
          maxWidth: 800.0,
        )

    );
  }
}


class _RecipeIngredientsView extends StatelessWidget {
  _RecipeIngredientsView(this.ingredients);

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(ingredients.join("\n",),
      style: const RecipeStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.black87))
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


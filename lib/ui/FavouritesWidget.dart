import 'package:flutter/material.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'dart:async';

class FavouritesWidget extends StatefulWidget {
  FavouritesWidget({this.favourites, this.onDelete});
  final List<Recipe> favourites;
  final ValueChanged<String> onDelete;

  FavouritesState createState() => new FavouritesState();
}

class FavouritesState extends State<FavouritesWidget> {
  List<Recipe> _favourites = new List<Recipe>();

  @override
  void initState() {
    super.initState();
    _favourites = widget.favourites;
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.extent(
        children: _favourites
            .map((i) => new FavouriteWidget(
                  recipe: i,
                  onChanged: _handleDelete,
                ))
            .toList(),
        maxCrossAxisExtent: 400.00);
  }

  void _handleDelete(String recipeid) {
    bool abort = false;
    Recipe recipe = _favourites.firstWhere((i) => i.recipeID == recipeid);
    setState(() {
    _favourites.remove(recipe);
    });

    new Timer(new Duration(seconds: 3), () {
      if (!abort) {
        widget.onDelete(recipeid);
      }
    });
    Scaffold.of(context).showSnackBar(
      new SnackBar(
          content: new Text("Deleted Favourite"),
          duration: new Duration(seconds: 3),
          action: new SnackBarAction(
              label: "Undo",
              onPressed: () {
                abort = true;
                setState(() {
                  _favourites.add(recipe);
                });
              })),
    );
  }
}

class FavouriteWidget extends StatelessWidget {
  final Recipe recipe;
  final ValueChanged<String> onChanged;
  FavouriteWidget({this.recipe, this.onChanged});

  void _onChanged(bool newValue) {
    onChanged(recipe.recipeID);
  }

  @override
  Widget build(BuildContext context) {
    return new GridTile(
      child: new RecipeImageWidget(recipe),
      footer: new GridTileBar(
        title: new RecipeText(recipe.title),
        subtitle: new RecipeText(recipe.publisher),
        backgroundColor: Colors.black54,
        trailing: new FavouriteDeleteIcon(
          onChanged: _onChanged,
        ),
      ),
    );
  }
}

class FavouriteDeleteIcon extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  FavouriteDeleteIcon({this.onChanged});

  void _handleChanged() {
    onChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.delete),
      onPressed: _handleChanged,
    );
  }
}

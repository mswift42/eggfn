import 'package:flutter/material.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'package:eggfn/services/FavouritesFileService.dart';
import 'dart:async';

class FavouritesWidget extends StatefulWidget {

  _FavouritesState createState() => new _FavouritesState();
}

class _FavouritesState extends State<FavouritesWidget> {
 List<Recipe> _favourites = new List<Recipe>();

  @override
  void initState() {
    super.initState();
    FavouritesFileService.readFavourites().then((List<Recipe> contents) {
      setState(() {
        _favourites = contents;
      });
    });
 }

  @override
  Widget build(BuildContext context) {
    return new GridView.extent(
      children: _favourites.map((i) => new FavouriteWidget(
        recipe: i,
      )).toList(),
        maxCrossAxisExtent: 400.00);
  }

  void _handleDelete(String recipeid) {

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
        subtitle: new RecipeText(recipe.title),
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
}
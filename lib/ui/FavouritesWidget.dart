import 'package:flutter/material.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'package:eggfn/services/FavouritesFileService.dart';

class FavouritesWidget extends StatelessWidget {

  FavouritesWidget({this.favourites, this.onChanged});
 final List<Recipe> favourites;
 final ValueChanged<String> onChanged;



  @override
  Widget build(BuildContext context) {
    return new GridView.extent(
      children: favourites.map((i) => new FavouriteWidget(
        recipe: i,
        onChanged: _handleDelete,
      )).toList(),
        maxCrossAxisExtent: 400.00);
  }

  void _handleDelete(String recipeid) {
    onChanged(recipeid);
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
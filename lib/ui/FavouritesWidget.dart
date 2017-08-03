import 'package:flutter/material.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/FavouritesFileService.dart';
import 'dart:async';

class FavouritesWidget extends StatefulWidget {

  _FavouritesState createState() => new _FavouritesState();
}

class _FavouritesState extends State<FavouritesWidget> {
 List<Recipe> _favourites = new List<Recipe>();

  @override
  Widget build(BuildContext context) {
    return new GridView.extent(
      children: _favourites.map((i) => new FavouriteWidget(
        recipe: i,
      )).toList(),
        maxCrossAxisExtent: 400.00);
  }
}

class FavouriteWidget extends StatelessWidget {
  final Recipe recipe;
  FavouriteWidget({this.recipe});

  @override
  Widget build(BuildContext context) {
    return new GridTile(
        child: null);
  }
}
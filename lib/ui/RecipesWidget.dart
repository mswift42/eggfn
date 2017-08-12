import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;
import 'package:eggfn/services/FavouritesFileService.dart';
import 'package:eggfn/ui/FavouritesWidget.dart' show FavouritesWidget;
import 'package:flutter/foundation.dart';
import 'dart:async';

class EggCrackin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new RecipesHome(),
      theme: _kThemeData,
    );
  }
}

class RecipesHome extends StatefulWidget {
  RecipesHomeState createState() => new RecipesHomeState();
}

class RecipesHomeState extends State<RecipesHome> {
  ValueNotifier<bool> open = new ValueNotifier<bool>(false);
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

  void _handlePress() {
    setState(() {
      open.value = !open.value;
    });
  }
  void _addFavourite(Recipe recipe) {
    setState(() {
      _favourites.add(recipe);
    });
    FavouritesFileService.saveFavourites(_favourites.toSet());
  }

  void _deleteFavourite(String recipeid) {
    Recipe recipe = _favourites.firstWhere((i) => i.recipeID == recipeid);
    setState(() {
      _favourites.remove(recipe);
    });
    FavouritesFileService.saveFavourites(_favourites.toSet());
  }

  void showFavourites(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return new Scaffold(
                appBar: new AppBar(title: new Text("Favourites")),
                body: new FavouritesWidget(
                  favourites: _favourites,
                  onDelete: _deleteFavourite,
                ),
              );
            }));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("EggCrackin!"),
        actions: <Widget>[
          new IconButton(
              icon:
                  new Icon(Icons.search, color: Theme.of(context).buttonColor),
              onPressed: _handlePress),
          new IconButton(
              icon: new Icon(Icons.star),
              onPressed: () {
                showFavourites(context);
              }),
        ],
      ),
      body: new RecipesWidget(
        open: open,
        favourites: _favourites.toList(),
        onAdd: _addFavourite,
        onDelete: _deleteFavourite,
      ),
    );
  }
}

class RecipeSearch extends AnimatedWidget {
  final ValueNotifier<bool> open;
  RecipeSearch({@required this.open}) : super(listenable: open);
  @override
  Widget build(BuildContext context) {
    return new AnimatedCrossFade(
      firstChild: new Container(),
      secondChild: new RecipeSearchInput(),
      crossFadeState:
          open.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: new Duration(milliseconds: 300),
    );
  }
}

class RecipeSearchInput extends StatefulWidget {
  _RecipeSearchInputState createState() => new _RecipeSearchInputState();
}

class _RecipeSearchInputState extends State<RecipeSearchInput> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: _controller,
      onSubmitted: _handleSubmit,
      decoration:
          new InputDecoration(hintText: "Search for Recipes or Ingredients"),
    );
  }

  void _handleSubmit(String text) {
    // TODO Search using food2fork api.
    // TODO setup streambuilder to load recipes.
    print(text);
  }
}

class RecipesWidget extends StatefulWidget {
  // TODO load recipes asynchronously.
  final ValueNotifier<bool> open;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onDelete;
  final ValueChanged<Recipe> onAdd;
  final List<Recipe> favourites;
  RecipesWidget({this.open, this.onChanged, this.favourites,
  this.onDelete, this.onAdd});

  @override
  _RecipesState createState() => new _RecipesState();
}

// TODO on route pop setState for favourites.
// TODO add snackbar for undoing of favourite delete.
class _RecipesState extends State<RecipesWidget> {
  final List<Recipe> recipes = mockrecipes;


  bool _isFavourite(String recipeid) {
    return widget.favourites.any((i) => i.recipeID == recipeid);
  }

  void _handleFavouriteToggle(String recipeid) {
    Recipe recipe = recipes.firstWhere((i) => recipeid == i.recipeID);
      if (_isFavourite(recipeid)) {
        widget.onDelete(recipeid);
      } else {
        widget.onAdd(recipe);
      }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new RecipeSearch(open: widget.open),
      new Expanded(
        child: new GridView.extent(
            children: mockrecipes
                .map((i) => new RecipeWidget(
                      recipe: i,
                      isFavourite: _isFavourite(i.recipeID),
                      onChanged: _handleFavouriteToggle,
                    ))
                .toList(),
            maxCrossAxisExtent: 340.00),
      ),
    ]);
  }

}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);

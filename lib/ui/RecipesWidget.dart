import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget, LinkTextSpan;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/FavouritesFileService.dart';
import 'package:eggfn/ui/FavouritesWidget.dart' show FavouritesWidget;
import 'package:flutter/foundation.dart';
import 'package:eggfn/services/RecipeService.dart';
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

// TODO add Home route.
// TODO show frying egg image in home route.
// TODO add search route.
// TODO move recipeswidget to search route.
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
      _favourites = _favourites;
    });
    FavouritesFileService.saveFavourites(_favourites.toSet());
  }

  Future<Null> _deleteFavourite(String recipeid) async {
    _favourites = _favourites.where((i) => i.recipeID != recipeid).toList();
    FavouritesFileService.saveFavourites(_favourites.toSet());
  }

  void showFavourites(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text("Favourites")),
        body: new Builder(
          builder: (BuildContext context) {
            return new FavouritesWidget(
              favourites: _favourites,
              onDelete: _deleteFavourite,
            );
          },
        ),
      );
    }));
  }

  void showHelp() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Help"),
        ),
        body: new SearchHelp(),
      );
    }));
  }


  void showAbout() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("About"),
        ),
        body: new AboutView(),
      );
    }));
  }

  void showRecipes(String query) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(query),
          ),
         body: new RecipesWidget(),
          );
        }));
  }

  void onPopUpMenuButton(String value) {
    if (value == 'Help') {
      showHelp();
    } else if (value == 'About') {
      showAbout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(" EggCrackin!"),
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
          new PopupMenuButton<String>(
            onSelected: onPopUpMenuButton,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                    value: 'Help',
                    child: const Text("Help"),
                  ),
                  const PopupMenuItem<String>(
                    value: 'About',
                    child: const Text("About"),
                  ),
                ],
          ),
        ],
      ),
      // TODO fix height of image.
      body: new HomeScreenWidget(
          open: open,
        onSubmit: showRecipes,
      ),
//      body: new RecipesWidget(
//        open: open,
//        favourites: _favourites.toList(),
//        onAdd: _addFavourite,
//        onDelete: _deleteFavourite,
//      ),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  final ValueNotifier<bool> open;
  final ValueChanged<String> onSubmit;
  HomeScreenWidget({this.open, this.onSubmit});

  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new RecipeSearch(
          open: widget.open,
          onSubmit: widget.onSubmit,
        ),
        new WelcomeWidget(),
      ],
    );
  }
}

class RecipeSearch extends AnimatedWidget {
  final ValueNotifier<bool> open;
  final ValueChanged<String> onSubmit;
  RecipeSearch({@required this.open, @required this.onSubmit})
      : super(listenable: open);
  @override
  Widget build(BuildContext context) {
    return new AnimatedCrossFade(
      firstChild: new Container(),
      secondChild: new RecipeSearchInput(
        onSubmit: onSubmit,
      ),
      crossFadeState:
          open.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: new Duration(milliseconds: 300),
    );
  }
}

class RecipeSearchInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  RecipeSearchInput({this.onSubmit});

  @override
  _RecipeSearchInputState createState() => new _RecipeSearchInputState();
}

class _RecipeSearchInputState extends State<RecipeSearchInput> {
  final TextEditingController _controller = new TextEditingController();
  final RecipeService _recipeService = new RecipeService();

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
    widget.onSubmit(text);
  }
}

// TODO show spinner while loading of recipes.
// TODO show Landing Page on startup.
// TODO show more button when > 30 recipes available.
// TODO check for http status when loading recipes.
class RecipesWidget extends StatefulWidget {
  final ValueNotifier<bool> open;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onDelete;
  final ValueChanged<Recipe> onAdd;
  final List<Recipe> favourites;
  RecipesWidget(
      {this.open, this.onChanged, this.favourites, this.onDelete, this.onAdd});

  @override
  _RecipesState createState() => new _RecipesState();
}

class _RecipesState extends State<RecipesWidget> {
  List<Recipe> recipes = new List();
  final RecipeService _recipeService = new RecipeService();

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

  Future<Null> _handleSubmit(String query) async {
    var rs = await _recipeService.getRecipes(query);
    setState(() {
      recipes = rs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new RecipeSearch(
        open: widget.open,
        onSubmit: _handleSubmit,
      ),
      new Expanded(
        child: new GridView.extent(
          children: recipes
              .map((i) => new RecipeWidget(
                    recipe: i,
                    isFavourite: _isFavourite(i.recipeID),
                    onChanged: _handleFavouriteToggle,
                  ))
              .toList(),
          maxCrossAxisExtent: 340.00,
        ),
      ),
    ]);
  }
}

class InfoView extends StatelessWidget {
  final List<String> infoTexts;
  InfoView({this.infoTexts});
  Widget _infoText(BuildContext context, String text) {
    return new Padding(
      padding: new EdgeInsets.symmetric(
        vertical: 22.0,
        horizontal: 20.0,
      ),
      child: new Text(
        text,
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      heightFactor: 1.3,
      child: new Container(
        constraints: new BoxConstraints(
          maxHeight: 220.00,
        ),
        child: new Card(
          color: Colors.white,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 10.0,
                ),
              ),
              new Column(
                children: infoTexts.map((i) => _infoText(context, i)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new InfoView(
      infoTexts: [
        "Search for recipes with space seperated search terms.",
        "When searching by ingredients, supply search terms seperated by comma, with no space inbetween."
      ],
    );
  }
}

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextSpan _aboutSpan(String text) {
      return new TextSpan(
        text: text,
        style: Theme.of(context).textTheme.body2,
      );
    }

    List<RichText> contents = [
      new RichText(
          text: new TextSpan(children: <TextSpan>[
        _aboutSpan("EggCrackin! is a "),
        new LinkTextSpan(text: "Flutter ", url: "https://flutter.io"),
        _aboutSpan("app."),
      ])),
      new RichText(text: new TextSpan(text: " ")),
      new RichText(
        text: new TextSpan(
          children: <TextSpan>[
            _aboutSpan("It uses the "),
            new LinkTextSpan(text: "Food2Fork ", url: "food2fork.com"),
            _aboutSpan("api."),
          ],
        ),
      ),
      new RichText(text: new TextSpan(text: " ")),
      new RichText(
        text: new TextSpan(
          children: <TextSpan>[
            _aboutSpan("Source code on "),
            new LinkTextSpan(
                text: "github/mswift42/eggfn",
                url: "https://github.com/mswift42/eggfn"),
            _aboutSpan("."),
          ],
        ),
      ),
      new RichText(text: new TextSpan(text: " ")),
      new RichText(
          text: new TextSpan(
        children: <TextSpan>[
          _aboutSpan("The frying eggs image is taken from "),
          new LinkTextSpan(
              text: "pexels.com",
              url:
                  "https://www.pexels.com/photo/cooking-eggs-food-fried-eggs-236812/"),
          _aboutSpan("."),
        ],
      ))
    ];

    return new _AboutViewContainer(contents: contents);
  }
}

class _AboutViewContainer extends StatelessWidget {
  final List<RichText> contents;
  _AboutViewContainer({this.contents});

  @override
  Widget build(BuildContext context) {
    return new Center(
      heightFactor: 1.3,
      child: new Container(
        constraints: new BoxConstraints(
          maxHeight: 320.00,
        ),
        child: new Card(
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 20.0),
              ),
              new Padding(
                padding: new EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: new Column(
                  children: contents,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,

      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 22.0,
          ),
          child: new Text("Welcome to EggCrackin!",
              style: Theme.of(context).textTheme.headline),
        ),
        new Padding(
          padding: new EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 25.0,
          ),
          child: new Text("Click on Search Icon to get started.",
              style: Theme.of(context).textTheme.body2),
        ),
        new FittedBox(
          child: new Image.asset("images/fryingegg.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eggfn/services/Recipe.dart' show Recipe;
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:eggfn/services/RecipeService.dart';
import 'dart:async';

const double _kRecipeDetailAppBarHeight = 120.00;
const double _kRecipeDetailPublisherHeight = 28.00;

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
// TODO load Ingredients if recipe.ingredients = null.
class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final bool isFavourite;
  RecipeWidget({this.recipe, this.isFavourite, this.onChanged});
  final ValueChanged<String> onChanged;

  void _onChanged(bool newValue) {
    onChanged(recipe.recipeID);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new GridTile(
            child: new RecipeImageWidget(recipe),
            footer: new GridTileBar(
              title: new RecipeText(recipe.title),
              subtitle: new RecipeText(recipe.publisher),
              backgroundColor: Colors.black45,
              trailing: new RecipeFavouriteIcon(
                isFavourite: isFavourite,
                onChanged: _onChanged,
              ),
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
        appBar: new AppBar(
          title: new Text(recipe.title),
        ),
        body: new FittedBox(
          fit: BoxFit.contain,
          child: new Hero(
            tag: recipe.recipeID,
            child: new RecipeDetailViewer(recipe),
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

class RecipeDetailViewer extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailViewer(this.recipe);

  @override
  _RecipeDetailState createState() => new _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetailViewer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double deviceWidth = size.width;
    final double deviceHeight = size.height;
    final double imageHeight = deviceHeight / 3.0;
    final double appBarHeight = new AppBar().preferredSize.height;
    final double bottomHeight = deviceHeight -
        imageHeight -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return new Container(
      width: deviceWidth,
      height: deviceHeight -
          new AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
      child: new Hero(
        tag: widget.recipe.imageUrl,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RecipeDetailImageView(
                imageUrl: widget.recipe.imageUrl,
                height: imageHeight,
              ),
              new RecipeDetailBottomView(
                recipe: widget.recipe,
                height: bottomHeight,
              ),
            ]),
      ),
    );
  }
}

class RecipeDetailImageView extends StatelessWidget {
  final String imageUrl;
  final double height;

  RecipeDetailImageView({this.imageUrl, this.height});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        height: height,
        child: new Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class RecipeDetailBottomView extends StatelessWidget {
  final Recipe recipe;
  final double height;

  RecipeDetailBottomView({this.recipe, this.height});
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: height,
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RecipeDetailPublisherView(recipe),
            new Container(
              child: new Text("Ingredients:",
                  style: Theme.of(context).textTheme.subhead),
              margin: new EdgeInsets.symmetric(vertical: 16.0),
            ),
            new _RecipeIngredientsView(
                recipe: recipe,
                height: height - _kRecipeDetailPublisherHeight,
            ),
            new Padding(
              padding: new EdgeInsets.symmetric(
                vertical: 8.0,
              ),
            ),
          ]),
    );
  }
}

class RecipeDetailPublisherView extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPublisherView(this.recipe);
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        margin: new EdgeInsets.symmetric(vertical: 12.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new IconButton(
                onPressed: () {
                  _launchUrl(recipe.publisherUrl);
                },
                icon: new Icon(Icons.shop),
              ),
              new IconButton(
                onPressed: () {
                  _launchUrl(recipe.sourceUrl);
                },
                icon: new Icon(Icons.list),
              ),
            ]),
      ),
    );
  }
}

class _RecipeIngredientsView extends StatefulWidget {
  _RecipeIngredientsView({this.recipe, this.height});

  final Recipe recipe;
  final double height;
  _RecipeIngredientsState createState() =>new _RecipeIngredientsState();

}

class _RecipeIngredientsState extends State<_RecipeIngredientsView> {
  RecipeService _recipeService = new RecipeService();
  List<String> ingredients = new List();


  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _recipeService.getIngredients(widget.recipe.recipeID),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          print(snapshot.connectionState);

          switch (snapshot.connectionState) {
            default:
              List content = snapshot.data;
              return new Expanded(
                child: new GridView.extent(
                  children: content.map((i) => new _RecipeIngredientView(i))
                      .toList(),
                  maxCrossAxisExtent: 500.00,
                  crossAxisSpacing: 20.00,
                  childAspectRatio: 18.0,
                ),
              );
          }
        }
    );
  }
}


class _RecipeIngredientView extends StatelessWidget {
  final String ingredient;

  _RecipeIngredientView(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(
        vertical: 22.0,
        horizontal: 12.0,
      ),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
            ),
            new Text(
              ingredient,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.body1,
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
            ),
          ]),
    );
  }
}

class RecipeText extends StatelessWidget {
  const RecipeText(this.title);

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

class RecipeFavouriteIcon extends StatelessWidget {
  RecipeFavouriteIcon({this.isFavourite, this.onChanged});
  final bool isFavourite;
  final ValueChanged<bool> onChanged;

  void _toggleFavourite() {
    onChanged(!isFavourite);
  }

  @override
  Widget build(BuildContext context) {
    IconData favIcon = isFavourite ? Icons.star : Icons.star_border;
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
                launch(url);
              });
}

_launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}

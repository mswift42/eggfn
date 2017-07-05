import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart';

class MockOnPressedFunction implements Function {
  ValueChanged<bool> onChanged;

  void call(bool newValue) {
    onChanged(newValue);
  }
}

void main() {
  Recipe rec = mockrecipes[0];
  testWidgets('RecipeText has a Text child', (WidgetTester tester) async {
    await tester.pumpWidget(new RecipeText("testtitle"));
    FittedBox fb = tester.widget(find.byType(FittedBox));
    expect(fb.child.toString(), "Text(\"testtitle\")");
    expect(fb.fit, BoxFit.scaleDown);
    expect(find.text("testtitle"), findsOneWidget);
  });
  testWidgets('RecipeDetailPublisherView has two icon buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(new RecipeDetailPublisherView(rec));
    expect(find.byType(IconButton), findsNWidgets(2));
  });
  testWidgets('RecipeDetailImageView has a set height',
      (WidgetTester tester) async {
    await tester.pumpWidget(new RecipeDetailImageView(
      height: 400.00,
      imageUrl: rec.imageUrl,
    ));
    expect(find.byType(Container), findsOneWidget);
    SizedBox sb = tester.widget(find.byType(SizedBox));
    expect(sb.height, 400.00);
  });
  testWidgets('RecipeDetailViewer has all Children Widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(
        body: new RecipeDetailViewer(rec),
      ),
    ));
    expect(find.byType(Hero), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(RecipeDetailImageView), findsOneWidget);
    expect(find.byType(RecipeDetailBottomView), findsOneWidget);
  });
  testWidgets('RecipeFavouriteIcon has correct Icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(new Material(
      child: new RecipeFavouriteIcon(
        isFavourite: false,
        onChanged: null,
      ),
    ));
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);
    await tester.pumpWidget(new Material(
        child: new RecipeFavouriteIcon(
      isFavourite: true,
      onChanged: null,
    )));
    expect(find.byIcon(Icons.star_border), findsNothing);
    expect(find.byIcon(Icons.star), findsOneWidget);

    MockOnPressedFunction mockOnPressedFunction;

    setUp(() {
      mockOnPressedFunction = new MockOnPressedFunction();
    });
    await tester.pumpWidget(new Material(
      child: new RecipeFavouriteIcon(
        isFavourite: true,
        onChanged: mockOnPressedFunction,
      )
    ));
    await tester.tap(find.byType(IconButton));
    expect(mockOnPressedFunction.onChanged, false);
  });
}

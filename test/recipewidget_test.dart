import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart';

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
  testWidgets("RecipeDetailViewer's build method returns a Container Widget",
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(
        body: new RecipeDetailViewer(rec),
      ),
    ));
    expect(find.byType(Hero), findsOneWidget);
  });
}

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
    Container con = tester.widget(find.byType(Container));
    expect(con.child.children.length, 2);
  });
}

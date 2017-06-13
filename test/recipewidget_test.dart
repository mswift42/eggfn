import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eggfn/ui/RecipeWidget.dart';
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart';

void main() {
  testWidgets('RecipeWidget is a Container Widget', (WidgetTester tester) async {
    await tester.pumpWidget(new RecipeWidget(recipe))
  });
}
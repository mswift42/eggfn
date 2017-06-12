import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:eggfn/ui/RecipesWidget.dart';

void main() {
  testWidgets('EggCrackin uses _kThemeData', (WidgetTester tester) async {
    await tester.pumpWidget(new EggCrackin());
    MaterialApp map = tester.widget(find.byType(MaterialApp));
      expect(map.theme.brightness, Brightness.light);
      expect(map.theme.accentColor, Colors.pink);
      expect(map.theme.buttonColor, Colors.grey[200]);
  });
  testWidgets('Eggcrackin Widgets home is RecipesHome', (WidgetTester tester) async {
    await tester.pumpWidget(new EggCrackin());
    MaterialApp map = tester.widget(find.byType(MaterialApp));
    expect(map.home.toString(), 'RecipesHome');
  });
}

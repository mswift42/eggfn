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
  testWidgets('Eggcrackin Widgets home is RecipesHome',
      (WidgetTester tester) async {
    await tester.pumpWidget(new EggCrackin());
    MaterialApp map = tester.widget(find.byType(MaterialApp));
    expect(map.home.toString(), 'RecipesHome');
  });
  testWidgets('RecipesHome is a Scaffold Widget', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new RecipesHome()));
    Scaffold scf = tester.widget(find.byType(Scaffold));
    expect(scf.appBar.toString(), 'AppBar');
  });
  testWidgets("AboutView's parent widget is a Center Widget", (WidgetTester tester) async {
    await tester.pumpWidget(new AboutView());
    expect(find.byType(Center), findsOneWidget);
  });
  testWidgets("AboutView has multiple RichText Widgets", (WidgetTester tester) async {
    await tester.pumpWidget(new AboutView());
    expect(find.byType(RichText), findsWidgets);
  });
}

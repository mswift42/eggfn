import 'package:eggfn/services/RecipeService.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var key = '7987c43afcf8a03a964bbcb0c9152c84';
  test('expect queryUrl to return correct Url', () {
    RecipeService rs = new RecipeService();
    var qu = rs.queryUrl("bacon");
    expect(qu, "http://food2fork.com/api/search?key=$key&q=bacon");
    var qu1 = rs.queryUrl("bacon,eggs");
    expect(qu1, "http://food2fork.com/api/search?key=$key&q=bacon,eggs");
    var qu2 = rs.queryUrl("bacon,eggs tomatoes");
    expect(qu2, "http://food2fork.com/api/search?key=$key&q=bacon,eggs+tomatoes");
  });
  test('expect queryPage to add correct pagenumber', () {
     RecipeService rs = new RecipeService();
     var queryurl = "http://food2fork.com/api/search?key=$key&q=bacon,eggs";
     var qp = rs.queryPage(queryurl, 2);
     expect(qp, queryurl + "&page=2");
    var qp2 = rs.queryPage(queryurl, 14);
    expect(qp2, "http://food2fork.com/api/search?key=$key&q=bacon,eggs&page=14");
  });
}
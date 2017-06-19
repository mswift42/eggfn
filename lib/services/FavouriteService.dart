import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class FavouriteService {
  Set<String> _favourites = new Set<String>();

  Set<String> get favourites => _favourites;

  void addFavourite(String recipeid) {
    _favourites.add(recipeid);
  }

  void deleteFavourite(String recipeid) {
    _favourites.remove(recipeid);
  }

  bool isFavourite(String recipeid) {
    return _favourites.contains(recipeid);
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/favourites.txt');
  }
}


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



}
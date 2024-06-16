class PokeImage {
  getPokemonPicture(String imageId) {
    final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/'
        'master/sprites/pokemon/$imageId.png';
    return imageUrl;
  }
}

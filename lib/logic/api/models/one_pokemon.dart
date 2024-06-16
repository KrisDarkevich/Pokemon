class OnePokemon {
  final String name;
  final String url;

  OnePokemon(this.name, this.url);

  factory OnePokemon.fromJson(Map<String, dynamic> json) {
    return OnePokemon(
      json['name'] as String,
      json['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'Results{name: $name, url: $url}';
  }
}

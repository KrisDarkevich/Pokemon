class PokemonApi {
  final int count;
  final String? next;
  final String? previous;
  final List<Results> results;

  PokemonApi(
    this.count,
    this.next,
    this.previous,
    this.results,
  );

  factory PokemonApi.fromJson(Map<String, dynamic> json) {
    return PokemonApi(
      json['count'] as int,
      json['next'] as String?,
      json['previous'] as String?,
      List<Results>.from(
        json['results'].map(
          (e) => Results.fromJson(e),
        ),
      ),
    );
  }
}

class OnePokemon {
  final int baseExperience;

  OnePokemon(this.baseExperience);

  factory OnePokemon.fromJson(Map<String, dynamic> json) {
    return OnePokemon(
      json['base_experience'] as int,
    );
  }
}

class Results {
  final String name;
  final String url;

  Results(this.name, this.url);

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      json['name'] as String,
      json['url'] as String,
    );
  }
}

// class ListResults{
//   final Results results;

//   ListResults(this.results);

//   factory ListResults.fromJson(Map<String, dynamic> json){return}
// }
// substring, regexp, split,
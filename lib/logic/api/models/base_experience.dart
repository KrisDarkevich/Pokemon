class BaseExperience {
  final int baseExperience;

  BaseExperience(this.baseExperience);

  factory BaseExperience.fromJson(Map<String, dynamic> json) {
    return BaseExperience(
      json['base_experience'] as int,
    );
  }
}

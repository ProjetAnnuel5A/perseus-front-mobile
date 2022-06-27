class ProfileUpdateDto {
  ProfileUpdateDto(
    this.birthDate,
    this.height,
    this.weight,
    this.availability,
    this.objective,
    this.level,
  );

  String birthDate;
  int? height;
  double? weight;

  List<String> availability;
  String objective;
  String level;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'birthDate': birthDate,
        'height': height,
        'weight': weight,
        'availability': availability,
        'objective': objective,
        'level': level
      };
}

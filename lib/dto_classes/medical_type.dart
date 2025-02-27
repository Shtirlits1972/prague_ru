class MedicalType {
  List<String> health_care = [];
  List<String> pharmacies = [];

  MedicalType(this.health_care, this.pharmacies);

  MedicalType.empty() {
    health_care = [];
    pharmacies = [];
  }

  /// Метод для создания объекта MedicalType из JSON
  factory MedicalType.fromJson(Map<String, dynamic> json) {
    return MedicalType(
      List<String>.from(json['health_care'] ?? []),
      List<String>.from(json['pharmacies'] ?? []),
    );
  }

  @override
  String toString() {
    return 'MedicalType: {health_care: $health_care, pharmacies: $pharmacies }';
  }
}

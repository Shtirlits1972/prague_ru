class Address {
  final String addressCountry;
  final String addressFormatted;
  final String streetAddress;
  final String postalCode;
  final String addressLocality;
  final String addressRegion;

  Address({
    required this.addressCountry,
    required this.addressFormatted,
    required this.streetAddress,
    required this.postalCode,
    required this.addressLocality,
    required this.addressRegion,
  });

  // Десериализация JSON в объект Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressCountry: json['address_country'],
      addressFormatted: json['address_formatted'],
      streetAddress: json['street_address'],
      postalCode: json['postal_code'],
      addressLocality: json['address_locality'],
      addressRegion: json['address_region'],
    );
  }

  // Сериализация объекта Address в JSON
  Map<String, dynamic> toJson() {
    return {
      'address_country': addressCountry,
      'address_formatted': addressFormatted,
      'street_address': streetAddress,
      'postal_code': postalCode,
      'address_locality': addressLocality,
      'address_region': addressRegion,
    };
  }
}

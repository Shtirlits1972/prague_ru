// Класс CustomImage с префиксом
class CustomImage {
  final String url;

  CustomImage({
    required this.url,
  });

  // Десериализация JSON в объект CustomImage
  factory CustomImage.fromJson(Map<String, dynamic> json) {
    return CustomImage(
      url: json['url'],
    );
  }

  // Сериализация объекта CustomImage в JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

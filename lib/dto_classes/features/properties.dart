import 'package:flutter/material.dart';
import 'package:prague_ru/dto_classes/features/adress.dart';
import 'package:prague_ru/dto_classes/features/custom_image.dart';

class Properties {
  final CustomImage image;
  final String content;
  final int id;
  final String name;
  final String perex;
  final List<dynamic> properties;
  final String updatedAt;
  final String url;
  final String district;
  final Address address;

  Properties({
    required this.image,
    required this.content,
    required this.id,
    required this.name,
    required this.perex,
    required this.properties,
    required this.updatedAt,
    required this.url,
    required this.district,
    required this.address,
  });

  // Десериализация JSON в объект Properties
  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      image: CustomImage.fromJson(json['image']),
      content: json['content'],
      id: json['id'],
      name: json['name'],
      perex: json['perex'],
      properties: List<dynamic>.from(json['properties']),
      updatedAt: json['updated_at'],
      url: json['url'],
      district: json['district'],
      address: Address.fromJson(json['address']),
    );
  }

  // Сериализация объекта Properties в JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image.toJson(),
      'content': content,
      'id': id,
      'name': name,
      'perex': perex,
      'properties': properties,
      'updated_at': updatedAt,
      'url': url,
      'district': district,
      'address': address.toJson(),
    };
  }
}

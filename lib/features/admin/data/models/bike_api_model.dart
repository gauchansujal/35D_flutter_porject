import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';

class BikeApiModel {
  final String? id;
  final String name;
  final String brand;
  final String price;
  final int engineCC;
  final String milage;
  final bool isAvailable;
  final String? imageUrl;

  const BikeApiModel({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.engineCC,
    required this.milage,
    this.isAvailable = true,
    this.imageUrl,
  });

  factory BikeApiModel.fromJson(Map<String, dynamic> json) {
    return BikeApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: json['price'] as String,
      engineCC: (json['engineCC'] as num).toInt(),
      milage: json['milage'] as String,
      // ✅ handles both 'isAvailable' and the typo 'isAvilable' in your DB
      isAvailable: (json['isAvailable'] ?? json['isAvilable']) as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'engineCC': engineCC,
      'milage': milage,
      'isAvailable': isAvailable,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  BikeEntity toEntity() => BikeEntity(
    id: id,
    name: name,
    brand: brand,
    price: price,
    engineCC: engineCC,
    milage: milage,
    isAvailable: isAvailable,
    imageUrl: imageUrl,
  );

  factory BikeApiModel.fromEntity(BikeEntity entity) => BikeApiModel(
    id: entity.id,
    name: entity.name,
    brand: entity.brand,
    price: entity.price,
    engineCC: entity.engineCC,
    milage: entity.milage,
    isAvailable: entity.isAvailable,
    imageUrl: entity.imageUrl,
  );
}

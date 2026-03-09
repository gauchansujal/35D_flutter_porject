import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';

class BikeModel {
  final String? id;
  final String name;
  final String brand;
  final String price;
  final int engineCC;
  final String milage;
  final bool isAvailable;
  final String? imageUrl;

  BikeModel({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.engineCC,
    required this.milage,
    required this.isAvailable,
    this.imageUrl,
  });
  //to json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "price": price,
      "engineCC": engineCC,
      "milage": milage,
      "isAvailable": isAvailable,
      "imageUrl": imageUrl,
    };
  }

  //from json
  factory BikeModel.formJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: json['price'] as String,
      engineCC: json['engineCC'] as int,
      milage: json['milage'] as String,
      isAvailable: json['isAvailable'] as bool,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
  // toenytity
  BikeEntity toEntity() {
    return BikeEntity(
      id: id,
      name: name,
      brand: brand,
      engineCC: engineCC,
      milage: milage,
      isAvailable: isAvailable,
      imageUrl: imageUrl,
      price: price,
    );
  }

  //from Enttity
  factory BikeModel.fromEntity(BikeEntity entity) {
    return BikeModel(
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
  // toEntity list
  static List<BikeEntity> toEntityList(List<BikeModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

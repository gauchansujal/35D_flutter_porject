import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';

class BikeEntity extends Equatable {
  final String? id;
  final String name;
  final String brand;
  final int engineCC; // ✅ lowercase int, no dart:ffi import
  final String milage;
  final bool isAvailable;
  final String? imageUrl;
  final String price;

  const BikeEntity({
    this.id,
    required this.name,
    required this.brand,
    required this.engineCC,
    required this.milage,
    required this.isAvailable,
    this.imageUrl,
    required this.price,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    engineCC,
    milage,
    isAvailable,
    imageUrl,
    price,
  ];

  // ✅ engineCC added + return statement added
  BikeEntity copyWith({
    // added copyWith mwthod for easire updates 👉 Because your entity is immutable (final fields) you cannot modify it directly So we copy + change only needed fields
    String? id,
    String? name,
    String? brand,
    int? engineCC,
    String? milage,
    bool? isAvailable,
    String? imageUrl,
    String? price,
  }) {
    return BikeEntity(
      // 🧠 Important operator ?? = if left is null → use right value Meaning: if new id provided → use it else → keep old id
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      engineCC: engineCC ?? this.engineCC,
      milage: milage ?? this.milage,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  // Full image URL (used in UI)
  // In bike_entity.dart – replace your current fullImageUrl with this
  String get fullImageUrl {
    final path = imageUrl ?? '';
    if (path.isEmpty) return '';

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Take baseUrl but REMOVE /api if present
    String base = ApiEndpoints.baseUrl;
    if (base.endsWith('/api/') || base.endsWith('/api')) {
      base = base.replaceAll(RegExp(r'/api/?$'), '');
    }

    final cleanBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final cleanPath = path.startsWith('/') ? path : '/$path';

    return '$cleanBase$cleanPath';
  }
}

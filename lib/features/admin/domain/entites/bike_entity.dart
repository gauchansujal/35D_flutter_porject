class BikeEntity {
  final String? id;
  final String name;
  final String brand;
  final String price;
  final int engineCC;
  final String milage;
  final bool isAvailable;
  final String? imageUrl;

  const BikeEntity({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.engineCC,
    required this.milage,
    this.isAvailable = true,
    this.imageUrl,
  });
}
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';

class BookingModel {
  final String? id;
  final String? userId;
  final String? bikeId;
  final DateTime? bookingDate; // optional
  final DateTime? returnDate; // optional
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookingModel({
    this.id,
    this.userId,
    this.bikeId,
    this.bookingDate,
    this.returnDate,
    this.createdAt,
    this.updatedAt,
  });

  // toJson — used when SENDING to backend (only send what backend expects)
  Map<String, dynamic> toJson() {
    return {
      "user": userId,
      "bike": bikeId,
      if (bookingDate != null) "bookingDate": bookingDate!.toIso8601String(),
      if (returnDate != null) "returnDate": returnDate!.toIso8601String(),
    };
  }

  // fromJson — maps your exact backend response
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] as String?, // MongoDB uses _id
      userId: json['user'] as String?, // FK comes as raw ObjectId string
      bikeId: json['bike'] as String?, // FK comes as raw ObjectId string
      bookingDate:
          json['bookingDate'] != null
              ? DateTime.parse(json['bookingDate'])
              : null,
      returnDate:
          json['returnDate'] != null
              ? DateTime.parse(json['returnDate'])
              : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  BookingEnitities toEntity() {
    return BookingEnitities(
      id: id,
      userId: userId,
      bikeId: bikeId,
      bookingDate: bookingDate,
      returnDate: returnDate,
      createdAt: createdAt,
      updateAt: updatedAt,
    );
  }

  //form Entitity
  factory BookingModel.fromEntity(BookingEnitities entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      bikeId: entity.bikeId,
      bookingDate: entity.bookingDate,
      returnDate: entity.returnDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updateAt,
    );
  }
  //to entity list
  static List<BookingEnitities> toEntityList(List<BookingModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

import 'package:equatable/equatable.dart';

class BookingEnitities extends Equatable {
  final String? id;
  final String? userId; //fk
  final String? bikeId; //fk
  final DateTime? bookingDate;
  final DateTime? returnDate;
  final DateTime? createdAt;
  final DateTime? updateAt;

  const BookingEnitities({
    this.id,
    this.userId,
    this.bikeId,
    this.bookingDate,
    this.returnDate,
    this.createdAt,
    this.updateAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    bikeId,
    bookingDate,
    returnDate,
    createdAt,
    updateAt,
  ];

  BookingEnitities copywith({
    String? id,
    String? userId,
    String? bikeId,
    DateTime? bookingDate,
    DateTime? returnDate,
    DateTime? createdAt,
    DateTime? updateAt,
  }) {
    return BookingEnitities(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bikeId: bikeId ?? this.bikeId,
      bookingDate: bookingDate ?? this.bookingDate,
      returnDate: returnDate ?? this.returnDate,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }
}

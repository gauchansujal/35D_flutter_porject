import 'package:equatable/equatable.dart';

class UplodeDocumentEntity extends Equatable {
  final String? id;
  final String? userId; //fk
  final String fullname;
  final String nationalId;
  final String nationalIdImageUrl;
  final String drivingLicense;
  final String drivingLicenseImageUrl;
  final String phoneNumber;

  const UplodeDocumentEntity({
    this.id,
    this.userId,
    required this.fullname,
    required this.nationalId,
    required this.nationalIdImageUrl,
    required this.drivingLicense,
    required this.drivingLicenseImageUrl,
    required this.phoneNumber,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    userId,
    fullname,
    nationalId,
    nationalIdImageUrl,
    drivingLicense,
    drivingLicenseImageUrl,
    phoneNumber,
  ];

  UplodeDocumentEntity copywith({
    String? id,
    String? userId,
    String? fullname,
    String? nationalId,
    String? nationalIdImageUrl,
    String? drivingLicense,

    String? drivingLicenseImageUrl,
    String? phoneNumber,
  }) {
    return UplodeDocumentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      nationalId: nationalId ?? this.nationalId,
      nationalIdImageUrl: nationalIdImageUrl ?? this.nationalIdImageUrl,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      drivingLicenseImageUrl:
          drivingLicenseImageUrl ?? this.drivingLicenseImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

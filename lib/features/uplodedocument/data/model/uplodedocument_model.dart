import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';

class UplodedocumentModel {
  final String? id;
  final String? userId; //fk
  final String fullname;
  final String nationalId;
  final String nationalIdImageUrl;
  final String drivingLicense;
  final String drivingLicenseImageUrl;
  final String phoneNumber;

  UplodedocumentModel({
    this.id,
    this.userId,
    required this.fullname,
    required this.nationalId,
    required this.nationalIdImageUrl,
    required this.drivingLicense,
    required this.drivingLicenseImageUrl,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "nationalId": nationalId,
      "nationalIdImageUrl": nationalIdImageUrl,
      "drivingLicense": drivingLicense,
      "drivingLicenseImageUrl": drivingLicenseImageUrl,
      "phoneNumber": phoneNumber,
    };
  }

  factory UplodedocumentModel.fromJson(Map<String, dynamic> json) {
    return UplodedocumentModel(
      id: json["id"],
      userId: json["userId"],
      fullname: json["fullname"],
      nationalId: json["nationalId"],
      nationalIdImageUrl: json["nationalIdImageUrl"],
      drivingLicense: json["drivingLicense"],
      drivingLicenseImageUrl: json["drivingLicenseImageUrl"],
      phoneNumber: json["phoneNumber"],
    );
  }
  UplodeDocumentEntity toEntity() {
    return UplodeDocumentEntity(
      id: id,
      userId: userId,
      fullname: fullname,
      nationalId: nationalId,
      nationalIdImageUrl: nationalIdImageUrl,
      drivingLicense: drivingLicense,
      drivingLicenseImageUrl: drivingLicenseImageUrl,
      phoneNumber: phoneNumber,
    );
  }

  //from Entity
  factory UplodedocumentModel.fromEntity(UplodeDocumentEntity entity) {
    return UplodedocumentModel(
      id: entity.id,
      userId: entity.userId,
      fullname: entity.fullname,
      nationalId: entity.nationalId,
      nationalIdImageUrl: entity.nationalIdImageUrl,
      drivingLicense: entity.drivingLicense,
      drivingLicenseImageUrl: entity.drivingLicenseImageUrl,
      phoneNumber: entity.phoneNumber,
    );
  }
  //to enityr list
  static List<UplodeDocumentEntity> toEntityList(
    List<UplodedocumentModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}

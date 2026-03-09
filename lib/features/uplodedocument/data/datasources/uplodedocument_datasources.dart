import 'package:flutter_application_1/features/uplodedocument/data/model/uplodedocument_model.dart';

abstract interface class IUploadDocumentRemoteDataSource {
  Future<UplodedocumentModel> getById(String id);
  Future<List<UplodedocumentModel>> getAll();
  Future<UplodedocumentModel> create(UplodedocumentModel booking);
  Future<void> update(String id, UplodedocumentModel booking);
  Future<void> delete(String id);
}

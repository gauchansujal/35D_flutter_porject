import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';
import 'package:flutter_application_1/features/uplodedocument/data/datasources/uplodedocument_datasources.dart';
import 'package:flutter_application_1/features/uplodedocument/data/model/uplodedocument_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UplodedocumentRemoteDatasourcesProvider =
    Provider<IUploadDocumentRemoteDataSource>((ref) {
      return UplodedocumentRemoteDatasources(
        apiClient: ref.read(apiClientProvider),
      );
    });

class UplodedocumentRemoteDatasources
    implements IUploadDocumentRemoteDataSource {
  final ApiClient _apiClient;

  UplodedocumentRemoteDatasources({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<UplodedocumentModel> create(UplodedocumentModel document) async {
    final response = await _apiClient.post(
      ApiEndpoints.uplodedocument,
      data: document.toJson(),
    );
    return UplodedocumentModel.fromJson(response.data);
  }

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiEndpoints.uplodedocument}/$id');
  }

  @override
  Future<List<UplodedocumentModel>> getAll() async {
    final response = await _apiClient.get(ApiEndpoints.uplodedocument);
    final List<dynamic> data = response.data;
    return data.map((json) => UplodedocumentModel.fromJson(json)).toList();
  }

  @override
  Future<UplodedocumentModel> getById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.uplodedocument}/$id');
    return UplodedocumentModel.fromJson(response.data);
  }

  @override
  Future<void> update(String id, UplodedocumentModel document) async {
    await _apiClient.put(
      '${ApiEndpoints.uplodedocument}/$id',
      data: document.toJson(),
    );
  }
}

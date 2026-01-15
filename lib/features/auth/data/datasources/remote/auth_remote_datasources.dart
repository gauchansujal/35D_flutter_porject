import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';


// create provider
final AuthRemoteDatasources = Provider<IAuthLocalDatasource>((ref)){
  return AuthRemoteDatasources(apiClient : ref.read(apiClientProvider), userSessionServiceProvider:ref.read(userSessionServiceProvider),);
}


class AuthRemoteDatasources implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  @override
  Future<AuthHiveModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) {
    // TODO: implement register
    throw UnimplementedError();
  }
}

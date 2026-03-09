import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
  sucess,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? authEntity;
  final String? errorMessage;
  //stroe image name temp
  final String? uploadPhotoName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.errorMessage,
    this.uploadPhotoName,
  });

  // Factory for initial state
  factory AuthState.initial() => const AuthState();

  // copyWith method
  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? errorMessage,
    String? uploadPhotoName,
    bool clearErrorMessage = false, // ← ADD THIS
    bool clearAuthEntity = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authEntity,
    errorMessage,
    uploadPhotoName,
  ];

  @override
  bool get stringify => true;
}

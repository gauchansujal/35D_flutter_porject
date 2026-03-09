import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';

enum AdminUserStatus { initial, loading, success, error }

class AdminUserState extends Equatable {
  final AdminUserStatus status;
  final List<UserEntity> users;
  final UserEntity? selectedUser;
  final String? errorMessage;
  final String? successMessage;
  final int currentPage; // ✅ ADD
  final int totalPages; // ✅ ADD
  final int totalItems; // ✅ ADD
  final int pageSize; // ✅ ADD

  const AdminUserState({
    this.status = AdminUserStatus.initial,
    this.users = const [],
    this.selectedUser,
    this.errorMessage,
    this.successMessage,
    this.currentPage = 1, // ✅ ADD
    this.totalPages = 1, // ✅ ADD
    this.totalItems = 0, // ✅ ADD
    this.pageSize = 10, // ✅ ADD
  });

  bool get isLoading => status == AdminUserStatus.loading;
  bool get isSuccess => status == AdminUserStatus.success;
  bool get isError => status == AdminUserStatus.error;
  bool get hasNextPage => currentPage < totalPages; // ✅ ADD
  bool get hasPrevPage => currentPage > 1; // ✅ ADD

  AdminUserState copyWith({
    AdminUserStatus? status,
    List<UserEntity>? users,
    UserEntity? selectedUser,
    String? errorMessage,
    String? successMessage,
    int? currentPage, // ✅ ADD
    int? totalPages, // ✅ ADD
    int? totalItems, // ✅ ADD
    int? pageSize, // ✅ ADD
  }) {
    return AdminUserState(
      status: status ?? this.status,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      errorMessage: errorMessage,
      successMessage: successMessage,
      currentPage: currentPage ?? this.currentPage, // ✅ ADD
      totalPages: totalPages ?? this.totalPages, // ✅ ADD
      totalItems: totalItems ?? this.totalItems, // ✅ ADD
      pageSize: pageSize ?? this.pageSize, // ✅ ADD
    );
  }

  @override
  List<Object?> get props => [
    status, users, selectedUser,
    errorMessage, successMessage,
    currentPage, totalPages, totalItems, pageSize, // ✅ ADD
  ];
}

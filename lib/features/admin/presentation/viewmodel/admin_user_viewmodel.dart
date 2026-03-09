import 'dart:io';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/admin/data/repositories/admin_repository.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/create_user_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/delete_user_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/get_user_by_id_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/getall_users_usecases.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/update_user_usecase.dart';
import 'package:flutter_application_1/features/admin/presentation/provider/state/admin_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminUserViewModelProvider =
    StateNotifierProvider<AdminUserViewModel, AdminUserState>((ref) {
      final repo = ref.read(adminUserRepositoryProvider);
      return AdminUserViewModel(
        getAllUsersUseCase: GetAllUsersUseCase(repo),
        getUserByIdUseCase: GetUserByIdUseCase(repo),
        createUserUseCase: CreateUserUseCase(repo),
        updateUserUseCase: UpdateUserUseCase(repo),
        deleteUserUseCase: DeleteUserUseCase(repo),
      );
    });

class AdminUserViewModel extends StateNotifier<AdminUserState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminUserViewModel({
    required this.getAllUsersUseCase,
    required this.getUserByIdUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(const AdminUserState());

  // ── GET ALL with pagination ───────────────────────
  Future<void> fetchAllUsers({int page = 1, String? search}) async {
    // ✅ updated
    state = state.copyWith(status: AdminUserStatus.loading);
    try {
      final result = await getAllUsersUseCase(
        page: page,
        size: state.pageSize,
        search: search,
      );
      state = state.copyWith(
        status: AdminUserStatus.success,
        users: result.users, // ✅ only this page
        currentPage: result.page, // ✅ from backend
        totalPages: result.totalPages, // ✅ from backend
        totalItems: result.totalItems, // ✅ from backend
      );
    } on ApiFailure catch (e) {
      state = state.copyWith(
        status: AdminUserStatus.error,
        errorMessage: e.message,
      );
    }
  }

  // ── GET BY ID ────────────────────────────────────
  Future<void> fetchUserById(String id) async {
    state = state.copyWith(status: AdminUserStatus.loading);
    try {
      final user = await getUserByIdUseCase(id);
      state = state.copyWith(
        status: AdminUserStatus.success,
        selectedUser: user,
      );
    } on ApiFailure catch (e) {
      state = state.copyWith(
        status: AdminUserStatus.error,
        errorMessage: e.message,
      );
    }
  }

  // ── CREATE ───────────────────────────────────────
  Future<void> createUser({
    required String email,
    required String username,
    required String password,
    required String role,
    File? imageFile,
  }) async {
    state = state.copyWith(status: AdminUserStatus.loading);
    try {
      await createUserUseCase(
        CreateUserParams(
          email: email,
          username: username,
          password: password,
          role: role,
          imageFile: imageFile,
        ),
      );
      // ✅ refetch page 1 so list is fresh
      await fetchAllUsers(page: state.currentPage);
      state = state.copyWith(successMessage: 'User created successfully');
    } on ApiFailure catch (e) {
      state = state.copyWith(
        status: AdminUserStatus.error,
        errorMessage: e.message,
      );
    }
  }

  // ── UPDATE ───────────────────────────────────────
  Future<void> updateUser({
    required String id,
    required String email,
    required String username,
    required String role,
    File? imageFile,
  }) async {
    state = state.copyWith(status: AdminUserStatus.loading);
    try {
      final updated = await updateUserUseCase(
        UpdateUserParams(
          id: id,
          email: email,
          username: username,
          role: role,
          imageFile: imageFile,
        ),
      );
      state = state.copyWith(
        status: AdminUserStatus.success,
        users: state.users.map((u) => u.id == id ? updated : u).toList(),
        successMessage: 'User updated successfully',
      );
    } on ApiFailure catch (e) {
      state = state.copyWith(
        status: AdminUserStatus.error,
        errorMessage: e.message,
      );
    }
  }

  // ── DELETE ───────────────────────────────────────
  Future<void> deleteUser(String id) async {
    state = state.copyWith(status: AdminUserStatus.loading);
    try {
      await deleteUserUseCase(id);
      // ✅ refetch current page so pagination stays correct
      await fetchAllUsers(page: state.currentPage);
      state = state.copyWith(successMessage: 'User deleted successfully');
    } on ApiFailure catch (e) {
      state = state.copyWith(
        status: AdminUserStatus.error,
        errorMessage: e.message,
      );
    }
  }
}

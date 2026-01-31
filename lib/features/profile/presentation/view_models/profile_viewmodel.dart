import 'dart:io';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/profile/domain/usecases/uplode_photo_usecase.dart';
import 'package:flutter_application_1/features/profile/presentation/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProfileViewModelProvider =
    NotifierProvider<ProfileViewmodel, ProfileState>(ProfileViewmodel.new);

class ProfileViewmodel extends Notifier<ProfileState> {
  late final UplodePhotoUsecase _uplodePhotoUsecase;

  @override
  ProfileState build() {
    _uplodePhotoUsecase = ref.read(UplodePhotoUsecaseProvider);
    return const ProfileState();
  }

  Future<void> uploadPhoto(File photo) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _uplodePhotoUsecase(photo);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) {
        state = state.copyWith(
          status: ProfileStatus.loaded,
          uploadPhotoName: imageName,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSelectedProfile() {
    state = state.copyWith(errorMessage: null);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';


enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updating,
  success,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  /// Name of the file selected for upload (local path or just filename)
  /// Usually used during the "pick image → before upload" phase
  final String? uploadPhotoName;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.uploadPhotoName,
  });

  // ── Factory constructors for common states ─────────────────────────────────

  factory ProfileState.initial() => const ProfileState(
        status: ProfileStatus.initial,
      );

  factory ProfileState.loading() => const ProfileState(
        status: ProfileStatus.loading,
      );

  factory ProfileState.loaded(ProfileEntity profile) => ProfileState(
        status: ProfileStatus.loaded,
        profile: profile,
      );

  factory ProfileState.error(String? message) => ProfileState(
        status: ProfileStatus.error,
        errorMessage: message ?? 'An unknown error occurred',
      );

  factory ProfileState.updating({
    ProfileEntity? currentProfile,
    String? uploadingPhotoName,
  }) =>
      ProfileState(
        status: ProfileStatus.updating,
        profile: currentProfile,
        uploadPhotoName: uploadingPhotoName,
      );

  factory ProfileState.success(ProfileEntity updatedProfile) => ProfileState(
        status: ProfileStatus.success,
        profile: updatedProfile,
      );

  // ── copyWith ──────────────────────────────────────────────────────────────

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    String? uploadPhotoName,
    bool? clearUploadPhoto, // convenient way to reset filename after upload
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName:
          clearUploadPhoto == true ? null : (uploadPhotoName ?? this.uploadPhotoName),
    );
  }

  // ── Equatable props ───────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
        status,
        profile,
        errorMessage,
        uploadPhotoName,
      ];

  @override
  bool get stringify => true;

  // ── Convenience getters (optional but very useful) ────────────────────────

  bool get isLoading => status == ProfileStatus.loading;
  bool get isUpdating => status == ProfileStatus.updating;
  bool get isSuccess => status == ProfileStatus.success;
  bool get hasError => status == ProfileStatus.error;
  bool get hasProfile => profile != null;
}
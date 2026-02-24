import 'package:equatable/equatable.dart';

import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';

enum UploadDocumentStatus {
  initial,
  loading, // for fetching list
  uploading, // specifically during document creation/upload
  success,
  error,
}

class UploadDocumentState extends Equatable {
  final UploadDocumentStatus status;
  final List<UplodeDocumentEntity> documents;
  final String? errorMessage;
  final bool isUploading;

  const UploadDocumentState({
    this.status = UploadDocumentStatus.initial,
    this.documents = const [],
    this.errorMessage,
    this.isUploading = false,
  });

  // This is now a const constructor → allows const usage
  const UploadDocumentState.initial()
    : status = UploadDocumentStatus.initial,
      documents = const [],
      errorMessage = null,
      isUploading = false;

  UploadDocumentState copyWith({
    UploadDocumentStatus? status,
    List<UplodeDocumentEntity>? documents,
    String? errorMessage,
    bool? isUploading,
  }) {
    return UploadDocumentState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      errorMessage: errorMessage ?? this.errorMessage,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  @override
  List<Object?> get props => [status, documents, errorMessage, isUploading];

  @override
  bool get stringify => true;
}

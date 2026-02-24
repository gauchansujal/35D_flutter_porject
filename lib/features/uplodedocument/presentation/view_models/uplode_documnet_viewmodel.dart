import 'package:flutter_application_1/features/uplodedocument/data/repository/uplodedocumnet_repository.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/repositores/uplodedocument_repository.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/providers/state/uplode_document_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadDocumentViewModelProvider =
    NotifierProvider<UploadDocumentViewModel, UploadDocumentState>(
      UploadDocumentViewModel.new,
    );

class UploadDocumentViewModel extends Notifier<UploadDocumentState> {
  late final IUplodeDocumnetRepsitory _repository;

  @override
  UploadDocumentState build() {
    _repository = ref.read(UplodedocumnetRepositoryProvider);
    // Optional: auto load documents when viewmodel is first created
    // Future.microtask(fetchDocuments);
    return const UploadDocumentState.initial();
  }

  // ─── Upload / Create document ───────────────────────────────────
  Future<void> createDocument(UplodeDocumentEntity entity) async {
    state = state.copyWith(
      isUploading: true,
      status: UploadDocumentStatus.uploading,
      errorMessage: null,
    );

    final result = await _repository.create(entity);

    state = result.fold(
      (failure) => state.copyWith(
        isUploading: false,
        status: UploadDocumentStatus.error,
        errorMessage: failure.message ?? 'Failed to upload document',
      ),
      (newDocument) => state.copyWith(
        isUploading: false,
        status: UploadDocumentStatus.success,
        documents: [...state.documents, newDocument],
        errorMessage: null,
      ),
    );
  }

  // ─── Fetch / Load all documents ─────────────────────────────────
  Future<void> fetchDocuments() async {
    state = state.copyWith(
      status: UploadDocumentStatus.loading,
      errorMessage: null,
    );

    final result = await _repository.getAll();

    state = result.fold(
      (failure) => state.copyWith(
        status: UploadDocumentStatus.error,
        errorMessage: failure.message ?? 'Could not load documents',
      ),
      (docs) => state.copyWith(
        status: UploadDocumentStatus.success,
        documents: docs,
        errorMessage: null,
      ),
    );
  }

  // ─── Delete document ────────────────────────────────────────────
  Future<void> deleteDocument(String id) async {
    state = state.copyWith(
      status: UploadDocumentStatus.loading,
      errorMessage: null,
    );

    final result = await _repository.delete(id);

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => throw UnimplementedError());
      state = state.copyWith(
        status: UploadDocumentStatus.error,
        errorMessage: failure.message ?? 'Failed to delete document',
      );
      return;
    }

    // Safest: refresh entire list
    await fetchDocuments();

    // Optional optimistic version (faster UI, but can be inconsistent if server fails silently):
    // state = state.copyWith(
    //   documents: state.documents.where((doc) => doc.id != id).toList(),
    //   status: UploadDocumentStatus.success,
    // );
  }

  // ─── Update document ────────────────────────────────────────────
  Future<void> updateDocument(String id, UplodeDocumentEntity updated) async {
    state = state.copyWith(
      status: UploadDocumentStatus.loading,
      errorMessage: null,
    );

    final result = await _repository.update(id, updated);

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => throw UnimplementedError());
      state = state.copyWith(
        status: UploadDocumentStatus.error,
        errorMessage: failure.message ?? 'Failed to update document',
      );
      return;
    }

    // Safest & most consistent: refresh list
    await fetchDocuments();

    // Optional optimistic update:
    // state = state.copyWith(
    //   documents: state.documents.map((doc) => doc.id == id ? updated : doc).toList(),
    //   status: UploadDocumentStatus.success,
    //   errorMessage: null,
    // );
  }

  // ─── Helpers ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const UploadDocumentState.initial();
  }
}

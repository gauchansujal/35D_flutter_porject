import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/uplodedocument/data/repository/uplodedocumnet_repository.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/repositores/uplodedocument_repository.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/providers/state/uplode_document_state.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/view_models/uplode_documnet_viewmodel.dart';

// ── Fake Repository ───────────────────────────────────────────────
class FakeUplodeDocumentRepository implements IUplodeDocumnetRepsitory {
  bool shouldFail = false;
  List<UplodeDocumentEntity> fakeList = [];

  @override
  Future<Either<Failure, UplodeDocumentEntity>> create(
    UplodeDocumentEntity entity,
  ) async {
    if (shouldFail) return Left(ApiFailure(message: 'Upload failed'));
    fakeList.add(entity);
    return Right(entity);
  }

  @override
  Future<Either<Failure, List<UplodeDocumentEntity>>> getAll() async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Could not load documents'));
    return Right(fakeList);
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Failed to delete document'));
    fakeList.removeWhere((doc) => doc.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> update(
    String id,
    UplodeDocumentEntity entity,
  ) async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Failed to update document'));
    fakeList = fakeList.map((doc) => doc.id == id ? entity : doc).toList();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, UplodeDocumentEntity>> getById(String id) async {
    if (shouldFail) return Left(ApiFailure(message: 'Not found'));
    return Right(fakeList.firstWhere((doc) => doc.id == id));
  }
}

// ── Fake Entity ───────────────────────────────────────────────────
final fakeEntity = UplodeDocumentEntity(
  id: '1',
  fullname: 'John Doe',
  nationalId: 'NID123',
  nationalIdImageUrl: '',
  drivingLicense: 'DL456',
  drivingLicenseImageUrl: '',
  phoneNumber: '9800000000',
);

// ── Helper ────────────────────────────────────────────────────────
ProviderContainer buildContainer(FakeUplodeDocumentRepository fakeRepo) {
  return ProviderContainer(
    overrides: [UplodedocumnetRepositoryProvider.overrideWithValue(fakeRepo)],
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  late FakeUplodeDocumentRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeUplodeDocumentRepository();
    container = buildContainer(fakeRepo);
  });

  tearDown(() {
    container.dispose();
  });

  // ── Initial State ──────────────────────────────────────────────
  group('initial state', () {
    test('starts with initial state', () {
      final state = container.read(uploadDocumentViewModelProvider);

      expect(state.status, UploadDocumentStatus.initial);
      expect(state.documents, isEmpty);
      expect(state.isUploading, isFalse);
      expect(state.errorMessage, isNull);
    });
  });

  // ── createDocument ─────────────────────────────────────────────
  group('createDocument', () {
    test('emits success and adds document', () async {
      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .createDocument(fakeEntity);

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.success);
      expect(state.documents, contains(fakeEntity));
      expect(state.isUploading, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('emits error when upload fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .createDocument(fakeEntity);

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.error);
      expect(state.errorMessage, 'Upload failed');
      expect(state.isUploading, isFalse);
    });
  });

  // ── fetchDocuments ─────────────────────────────────────────────
  group('fetchDocuments', () {
    test('emits success with documents', () async {
      fakeRepo.fakeList = [fakeEntity];

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .fetchDocuments();

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.success);
      expect(state.documents.length, 1);
    });

    test('emits error when fetch fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .fetchDocuments();

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.error);
      expect(state.errorMessage, 'Could not load documents');
    });
  });

  // ── deleteDocument ─────────────────────────────────────────────
  group('deleteDocument', () {
    test('removes document and refreshes list', () async {
      fakeRepo.fakeList = [fakeEntity];

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .deleteDocument('1');

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.success);
      expect(state.documents, isEmpty);
    });

    test('emits error when delete fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .deleteDocument('1');

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.error);
      expect(state.errorMessage, 'Failed to delete document');
    });
  });

  // ── updateDocument ─────────────────────────────────────────────
  group('updateDocument', () {
    test('updates document and refreshes list', () async {
      fakeRepo.fakeList = [fakeEntity];

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .updateDocument('1', fakeEntity);

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.success);
    });

    test('emits error when update fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .updateDocument('1', fakeEntity);

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.error);
      expect(state.errorMessage, 'Failed to update document');
    });
  });

  // ── Helpers ────────────────────────────────────────────────────
  group('helpers', () {
    test('clearError runs without crashing', () async {
      expect(
        () =>
            container
                .read(uploadDocumentViewModelProvider.notifier)
                .clearError(),
        returnsNormally,
      );
    });

    test('reset returns to initial state', () async {
      // first do something to change state
      fakeRepo.fakeList = [fakeEntity];
      await container
          .read(uploadDocumentViewModelProvider.notifier)
          .fetchDocuments();

      // now reset
      container.read(uploadDocumentViewModelProvider.notifier).reset();

      final state = container.read(uploadDocumentViewModelProvider);
      expect(state.status, UploadDocumentStatus.initial);
      expect(state.documents, isEmpty);
    });
  });
}

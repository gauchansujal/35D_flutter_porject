import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/uplodedocument/data/datasources/remote/uplodedocument_remote_datasources.dart';
import 'package:flutter_application_1/features/uplodedocument/data/datasources/uplodedocument_datasources.dart';
import 'package:flutter_application_1/features/uplodedocument/data/model/uplodedocument_model.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/repositores/uplodedocument_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UplodedocumnetRepositoryProvider = Provider<IUplodeDocumnetRepsitory>((
  ref,
) {
  final remoteDatasource = ref.read(UplodedocumentRemoteDatasourcesProvider);
  return UplodedocumnetRepository(remoteDatasource: remoteDatasource);
});

class UplodedocumnetRepository implements IUplodeDocumnetRepsitory {
  final IUploadDocumentRemoteDataSource _remoteDatasource;

  UplodedocumnetRepository({
    required IUploadDocumentRemoteDataSource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  // ─── Create ───────────────────────────────────────────────
  @override
  Future<Either<Failure, UplodeDocumentEntity>> create(
    UplodeDocumentEntity entity,
  ) async {
    try {
      final model = UplodedocumentModel.fromEntity(entity); // Entity → Model
      final result = await _remoteDatasource.create(model);
      return Right(result.toEntity()); // Model → Entity
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  // ─── Get All ──────────────────────────────────────────────
  @override
  Future<Either<Failure, List<UplodeDocumentEntity>>> getAll() async {
    try {
      final result = await _remoteDatasource.getAll();
      return Right(
        UplodedocumentModel.toEntityList(result),
      ); // List<Model> → List<Entity>
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  // ─── Get By Id ────────────────────────────────────────────
  @override
  Future<Either<Failure, UplodeDocumentEntity>> getById(String id) async {
    try {
      final result = await _remoteDatasource.getById(id);
      return Right(result.toEntity()); // Model → Entity
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  // ─── Update ───────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> update(
    String id,
    UplodeDocumentEntity entity,
  ) async {
    try {
      final model = UplodedocumentModel.fromEntity(entity); // Entity → Model
      await _remoteDatasource.update(id, model);
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  // ─── Delete ───────────────────────────────────────────────
  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await _remoteDatasource.delete(id);
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }
}

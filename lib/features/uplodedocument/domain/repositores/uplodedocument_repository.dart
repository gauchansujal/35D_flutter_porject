import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';

abstract interface class IUplodeDocumnetRepsitory {
  Future<Either<Failure, UplodeDocumentEntity>> create(
    UplodeDocumentEntity booking,
  ); // ✅ was Future<Either<Failure, List<UplodeDocumentEntity>>> createBooking()
  Future<Either<Failure, Unit>> delete(String id);
  Future<Either<Failure, List<UplodeDocumentEntity>>> getAll();
  Future<Either<Failure, UplodeDocumentEntity>> getById(String id);
  Future<Either<Failure, Unit>> update(String id, UplodeDocumentEntity booking);
}

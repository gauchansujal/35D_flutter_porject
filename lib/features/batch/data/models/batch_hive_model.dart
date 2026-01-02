import 'package:hive/hive.dart';
import 'packages:core/constants/hive_table_constant.dart';

  // Must match the filename exactly

@HiveType(typeId: 0)
class BatchHivemodel extends HiveObject {
  @HiveField(0)
  final String? batchId;

  @HiveField(1)
  final String batchName;

  @HiveField(2)
  final String? staus;

  

  BatchHiveModel({
    String? batchId, 
    required this.batchName,
    String? status
   
  })
  :batchId = batchId?? uuid().v4(),
  status= status?? 'active';
}
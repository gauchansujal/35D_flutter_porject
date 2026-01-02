class HiveTableConstant {
  HiveTableConstant._();

  //database name
  static const String dbName = 'bike_rental_app_db';

  //table names: Box names in hive
  static const int batchTypeId = 0;
  static const String batchTable = 'batch_table';

  static const int itemTypeId = 1;
  static const String itemTable = 'item_table';

  static const int authTypeId = 2;
  static const String authTable = 'auth_table';

  static const int categoryTypeId = 0;
  static const String categoryTable = 'category_table';

  static const int commentTypeId = 0;
  static const String commentTable = 'comment_table';
}

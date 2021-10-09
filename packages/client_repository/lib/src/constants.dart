abstract class Constants {
  static const String table = 'clients';

  static const String id = 'id';
  static const String avatarPath = 'avatarPath';
  static const String name = 'name';
  static const String city = 'city';
  static const String address = 'address';
  static const String phone = 'phone';
  static const String volume = 'volume';
  static const String previousDate = 'previousDate';
  static const String nextDate = 'nextDate';
  static const String images = 'images';
  static const String comment = 'comment';

  static const String initDatabase = '''
    CREATE TABLE IF NOT EXISTS $table (
      $id INTEGER PRIMARY KEY,
      $avatarPath TEXT NULL,
      $name TEXT,
      $city TEXT,
      $address TEXT NULL,
      $phone TEXT NULL,
      $volume TEXT NULL,
      $previousDate TEXT NULL,
      $nextDate TEXT NULL,
      $images TEXT NULL,
      $comment TEXT NULL
    )
  ''';
}

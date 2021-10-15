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

  static Map<String, Map<Type, bool>> fields = {
    id: {int: false},
    avatarPath: {String: true},
    name: {String: false},
    city: {String: false},
    address: {String: true},
    phone: {String: true},
    volume: {String: true},
    previousDate: {String: true},
    nextDate: {String: true},
    images: {String: true},
    comment: {String: true},
  };
}

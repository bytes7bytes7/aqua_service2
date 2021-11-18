const String table = 'clients';
const String archiveTable = 'archived_clients';

const String id = 'id';
const String avatarPath = 'avatarPath';
const String name = 'name';
const String city = 'city';
const String address = 'address';
const String phone = 'phone';
const String volume = 'volume';
const String previousDate = 'previousDate';
const String nextDate = 'nextDate';
const String images = 'images';
const String comment = 'comment';

Map<String, Map<Type, bool>> fields = {
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

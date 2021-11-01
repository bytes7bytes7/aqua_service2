const String table = 'fabrics';

const String id = 'id';
const String title = 'title';
const String retailPrice = 'retailPrice';
const String purchasePrice = 'purchasePrice';

Map<String, Map<Type, bool>> fields = {
  id: {int: false},
  title: {String: false},
  retailPrice: {double: true},
  purchasePrice: {double: true},
};
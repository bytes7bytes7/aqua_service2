const String table = 'fabrics';
const String archiveTable = 'archived_fabrics';

const String id = 'id';
const String title = 'title';
const String retailPrice = 'retailPrice';
const String purchasePrice = 'purchasePrice';

// time for archive table
const String expiredTime = 'expiredTime';

Map<String, Map<Type, bool>> timeField = {
  expiredTime: {String: false},
};

Map<String, Map<Type, bool>> fields = {
  id: {int: false},
  title: {String: false},
  retailPrice: {int: true},
  purchasePrice: {int: true},
};
const String table = 'fabrics';
const String archiveTable = 'archived_fabrics';

const String id = 'id';
const String title = 'title';
const String retailPrice = 'retailPrice';
const String purchasePrice = 'purchasePrice';

// time for archive table
const String actualTime = 'actualTime';

Map<String, Map<Type, bool>> timeField = {
  actualTime: {String: false},
};

Map<String, Map<Type, bool>> fields = {
  id: {int: false},
  title: {String: false},
  retailPrice: {int: true},
  purchasePrice: {int: true},
};
const String table = 'orders';
const String archiveTable = 'archived_orders';

const String id = 'id';
const String client = 'client';
const String price = 'price';
const String fabrics = 'fabrics';
const String expenses = 'expenses';
const String date = 'date';
const String done = 'done';
const String comment = 'comment';

Map<String, Map<Type, bool>> fields = {
  id: {int: false},
  client: {int: false},
  price: {int: true},
  fabrics: {String: true},
  expenses: {int: true},
  date: {String: false},
  done: {bool: false},
  comment: {String: true},
};

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:fabric_repository/fabric_repository.dart';

class FabricsInherited extends InheritedWidget {
  const FabricsInherited({
    Key? key,
    required Widget child,
    required List<Fabric> selected,
  })  : _selected = selected,
        super(key: key, child: child);

  final List<Fabric> _selected;

  List<Fabric> get selected => _selected;

  void addItem(Fabric item) {
    _selected.add(item);
  }

  void setItems(Iterable<Fabric> items) {
    clear();
    _selected.addAll(items);
  }

  void removeOneItem(Fabric item) {
    _selected.remove(_selected.firstWhere((e) => e.id == item.id));
  }

  void removeAllItems(Fabric item) {
    _selected.removeWhere((e) => e.id == item.id);
  }

  void clear() {
    _selected.clear();
  }

  static FabricsInherited of(BuildContext context) {
    final FabricsInherited? result =
        context.dependOnInheritedWidgetOfExactType<FabricsInherited>();
    assert(result != null, 'No FabricsInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FabricsInherited oldWidget) =>
      const ListEquality().equals(selected, oldWidget.selected);
}

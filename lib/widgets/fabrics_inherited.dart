import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:fabric_repository/fabric_repository.dart';

class FabricsInherited extends InheritedWidget {
  const FabricsInherited({
    Key? key,
    required Widget child,
    required List<Fabric> selected,
    required bool isChoice,
  })  : _selected = selected,
        _isChoice = isChoice,
        super(key: key, child: child);

  final List<Fabric> _selected;
  final bool _isChoice;

  List<Fabric> get selected => _selected;
  bool get isChoice => _isChoice;

  void addItem(Fabric item) {
    if (!_selected.contains(item)) {
      _selected.add(item);
    }
  }

  void setItems(Iterable<Fabric> items) {
    clearItems();
    _selected.addAll(items);
  }

  void removeItem(Fabric item) {
    if (_selected.contains(item)) {
      _selected.remove(item);
    }
  }

  void clearItems() {
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

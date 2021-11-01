import 'models/fabric.dart';

abstract class FabricRepository {
  Future<void> initTable();

  Future<void> dropTable();

  Stream<List<Fabric>> fabrics();

  Future<Fabric> getFabric(int id);

  Future<void> addFabric(Fabric fabric);

  Future<void> addFabrics(List<Fabric> fabrics);

  Future<void> updateFabric(Fabric fabric);

  Future<void> deleteFabric(Fabric fabric);

  Future<void> deleteFabrics();
}
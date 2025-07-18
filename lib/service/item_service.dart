import 'package:pocketbase/pocketbase.dart';
import '../data/item.dart';

class ItemService {
  final PocketBase pb;

  ItemService(this.pb);

  Future<List<Item>> getAllItems() async {
    try {
      final result = await pb.collection('item').getFullList();
      return result.map(Item.fromRecord).toList();
    } catch (e) {
      print('아이템 전체 조회 실패: $e');
      return [];
    }
  }

  Future<Item?> getItemById(String id) async {
    try {
      final record = await pb.collection('item').getOne(id);
      return Item.fromRecord(record);
    } catch (e) {
      print('아이템 단건 조회 실패: $e');
      return null;
    }
  }

  Future<List<Item>> getItemsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final filter = ids.map((id) => "id='$id'").join(" || ");
      final result = await pb.collection('item').getFullList(filter: filter);
      return result.map(Item.fromRecord).toList();
    } catch (e) {
      print('여러 아이템 조회 실패: $e');
      return [];
    }
  }
}

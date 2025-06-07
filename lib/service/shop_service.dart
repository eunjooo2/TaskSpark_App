import 'package:pocketbase/pocketbase.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/util/pocket_base.dart';
import '../data/shop.dart';

class ShopService {
  /// 모든 상점 아이템을 가져옵니다.
  Future<List<Shop>> getAllShopItems() async {
    final result = await PocketB().pocketBase.collection('item').getFullList();

    return result.map(Shop.fromRecord).toList();
  }

  /// 특정 ID의 상점 아이템을 조회합니다.
  Future<Shop?> getItemById(String id) async {
    try {
      final record = await PocketB().pocketBase.collection('item').getOne(id);
      return Shop.fromRecord(record);
    } catch (e) {
      return null;
    }
  }

  Future<void> buyItem(String id) async {
    final user = await UserService().getProfile();
    final item = await getItemById(id);

    await UserService().updateUserPoints((user.points ?? 0) - item!.price);
  }
}

/*
{
    "image": "assets/images/q.png",
    "name": "방어권",
    "description": "할 일을 못해서 받는 불이익 방어하기",
    "price": "300",
  },
*/

import 'package:pocketbase/pocketbase.dart';

class Shop {
  final String id;
  final String image;
  final String title;
  final String description;
  final int price;
  final Map<String, dynamic>? metadata;

  Shop({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    this.metadata,
  });

  factory Shop.fromRecord(RecordModel record) {
    return Shop(
      id: record.data["id"],
      image: record.data["image"],
      title: record.data["title"],
      description: record.data["description"],
      price: record.data["price"],
      metadata: record.data["metadata"],
    );
  }
}

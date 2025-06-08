import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class Item {
  String id;
  String collectionId;
  String collectionName;
  String title;
  String description;
  int price;
  String image;
  Map<String, dynamic>? metadata;

  Item({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.metadata,
  });

  factory Item.fromRecord(RecordModel record) {
    return Item(
      id: record.id,
      collectionId: record.collectionId,
      collectionName: record.collectionName,
      title: record.data["title"] ?? "",
      description: record.data["description"] ?? "",
      price: record.data["price"] ?? 0,
      image: record.data["image"] ?? "",
      metadata: record.data["metadata"],
    );
  }

  String get imageUrl =>
      "https://pb.aroxu.me/api/files/$collectionId/$id/$image";

  Map<String, dynamic> toJson() => {
    "id": id,
    "collectionId": collectionId,
    "collectionName": collectionName,
    "title": title,
    "description": description,
    "price": price,
    "image": image,
    "metadata": metadata,
  };

  @override
  String toString() => jsonEncode(toJson());
}

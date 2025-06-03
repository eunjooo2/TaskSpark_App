import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hello Store Page!"),
    );
  }
}

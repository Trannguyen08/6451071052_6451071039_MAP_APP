import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}

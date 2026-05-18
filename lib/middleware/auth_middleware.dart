import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({super.priority});

  final GetStorage _storage = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final accessToken = _storage.read<String>('accessToken') ?? '';
    if (accessToken.isEmpty) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streamscape/constants.dart';
import 'package:streamscape/models/user_model.dart';
import 'package:streamscape/services/storage_service.dart';
import 'package:streamscape/utils/error_handler.dart';
import 'package:streamscape/widgets/custom_snackbar.dart';

class AuthService {
  final StorageService storageService = StorageService();

  Future<User?> isAuthenticated() async {
    try {
      final String token = await storageService.get(jwtKey);

      if (token.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body["status"] == "success") {
          return User.fromJson(body["data"]["user"]);
        }
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<User?> signup(
    BuildContext ctx,
    String displayName,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/users/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'displayName': displayName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body["status"] == "success") {
          final String token = body["token"];
          await storageService.set(jwtKey, token);

          return User.fromJson(body["data"]["user"]);
        }
      }
      ErrorHandler.handleError(ctx, response, "Unexpected error occurred");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<User?> signin(BuildContext ctx, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body["status"] == "success") {
          final String token = body["token"];
          await storageService.set(jwtKey, token);

          return User.fromJson(body["data"]["user"]);
        }
      }
      ErrorHandler.handleError(ctx, response, "Unexpected error occurred");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> signout(BuildContext ctx) async {
    try {
      await storageService.remove(jwtKey);
      CustomSnackBar.showSnackBar(ctx, "Signed out successfully");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

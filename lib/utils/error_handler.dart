import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streamscape/widgets/custom_snackbar.dart';

class ErrorHandler {
  static void handleError(
      BuildContext context, http.Response response, String msg) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final String message = body['message'] ?? msg;

      CustomSnackBar.showSnackBar(context, message);
    } else if (response.statusCode >= 500) {
      CustomSnackBar.showSnackBar(context, 'Internal server error');
    } else {
      CustomSnackBar.showSnackBar(context, 'Unexpected error occurred');
    }
  }

  static void handleException(BuildContext context, Exception e) {
    if (e is http.ClientException) {
      CustomSnackBar.showSnackBar(
        context,
        'Network Error: Please check your connection',
      );
    } else {
      CustomSnackBar.showSnackBar(
        context,
        e.toString(),
      );
    }
  }
}

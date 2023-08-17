import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_master/utils/show_snackbar.dart';

void httpErrorHanding({
  required http.Response res,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (res.statusCode) {
    case 200:
      onSuccess();
      break;
    case 401:
      print(jsonDecode(res.body)['message']);
      showSnackbar(context, jsonDecode(res.body)['message']);
      break;
    case 500:
      print(jsonDecode(res.body)['message']);
      showSnackbar(context, jsonDecode(res.body)['message']);
      break;
    default:
      print(jsonDecode(res.body));
      showSnackbar(context, jsonDecode(res.body));
  }
}

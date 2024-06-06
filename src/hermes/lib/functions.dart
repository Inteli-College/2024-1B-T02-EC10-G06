import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "dart:convert";

const storage = FlutterSecureStorage();

void saveToken(token) async {
  await storage.write(key: 'token', value: token);
}

String getToken(response) {
  var token = json.decode(response.body);
  print(token);
  return token['token'];
}

Future<String> getTokenFromStorage() async {
  var token = await storage.read(key: 'token');
  if (token != null) {
    return token;
  } else {
    throw Exception('Token not found');
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

dynamic postToken(String token) async {
  var response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}/auth/getPermission'),
    body: jsonEncode({'token': token}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get token');
  }
}

Future<String> getTokenFromStorage() async {
  var token = await storage.read(key: 'token');
  if (token != null) {
    return token;
  } else {
    throw Exception('Token not found');
  }
}

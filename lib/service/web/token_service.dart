import 'package:http/browser_client.dart' as http;
import 'package:sp_client/util/constants.dart';

Future<String> getToken({
  String baseUrl = tokenServiceUrl,
  String uid,
}) async {
  var response =
      await http.BrowserClient().post("$baseUrl/getToken", body: {'uid': uid});
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return null;
  }
}

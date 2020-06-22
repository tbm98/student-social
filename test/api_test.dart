import 'package:flutter_test/flutter_test.dart';
import 'package:studentsocial/rest_api/rest_client.dart';

main() {
  test("test api", () async {
    RestClient client = RestClient.create();
    final loginResult =
        await client.login('DTC16HD4802010001', 'Kh0ngc0dauem;');
    expect(loginResult.isSuccess(), true);
  });
}

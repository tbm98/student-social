// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('dang nhap', () {

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    String msv = 'DTC16HD4802010006';
    String pass = '';

    tap(SerializableFinder f) async{
      return driver.tap(f);
    }

    wait(SerializableFinder f) async{
      return driver.waitFor(f);
    }

    test('tc3', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await tap(find.byTooltip('Open navigation menu'));
      await tap(find.byValueKey('menu_login'));
      await tap(find.byValueKey('login_msv'));
      await driver.enterText(msv);
      await tap(find.byValueKey('login_pass'));
      await driver.enterText(pass);
      await tap(find.byValueKey('login_dangnhap'));
      await wait(find.text('Bạn không được để trống tài khoản mật khẩu'));
    });
  });
}
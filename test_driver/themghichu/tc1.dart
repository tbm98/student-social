// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('them ghi chu', () {

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

    tap(SerializableFinder f) async{
      return driver.tap(f);
    }

    wait(SerializableFinder f) async{
      return driver.waitFor(f);
    }

    test('tc1', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await tap(find.byValueKey('themghichu'));
      await tap(find.byValueKey('tieudeghichu'));
      await driver.enterText('Ghi chú mới');
      await tap(find.byValueKey('noidungghichu'));
      await driver.enterText('abcxyz');
      await tap(find.byValueKey('ghichu_yes'));
      await Future.delayed(Duration(seconds: 1));
    });
  });
}
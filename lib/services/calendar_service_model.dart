import 'package:studentsocial/models/entities/calendar.dart';
import 'package:studentsocial/models/entities/event.dart';
import 'package:studentsocial/models/entities/login_result.dart';

import 'calendar_service_communicate.dart';
import 'google_http_client.dart';
import 'google_sign_in.dart';

class CalendarServiceModel {
  GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
  CalendarServiceCommunicate calendarServiceCommunicate;
  bool loading = false;
  double loadingValue;
  String avatarUrl = '';
  LoginResult loginResult;
  List<EventStudentSocial> events = [];

  void loginAction() async {
    loading = true;
//    notifyListeners();
    final result = await googleSignInHelper.signInWithGoogle();

    loading = false;
//    loginDone(result);
    if (avatarUrl.isNotEmpty) {
//      stateAction = StateAction.logined;
    }
//    notifyListeners();
  }

  void uploadAction() async {
    loading = true;
//    notifyListeners();

    calendarServiceCommunicate =
        CalendarServiceCommunicate(GoogleHttpClient(loginResult.headers));
    await calendarServiceCommunicate.deleteOldCalendars();
    final calendar = await calendarServiceCommunicate.insertNewCalendars();
    if (calendar.summary != CalendarStudentSocial.summary) {
      return;
    }

    calendarServiceCommunicate.addEvents(events).listen((value) {
      loadingValue = value;
      if (loadingValue == 1) {
        loadingValue = null;
        loading = false;
//        stateAction = StateAction.uploaded;
      }
//      notifyListeners();
    });
  }
}

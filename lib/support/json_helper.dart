
import 'dart:convert';

import 'package:studentsocial/models/object/semester.dart';

class JsonHelper{

  Semester parseSemeter(String response){
    // da check response tu truoc , dam bao response co gia tri
    return Semester.fromJson(json.decode(response));
  }
}
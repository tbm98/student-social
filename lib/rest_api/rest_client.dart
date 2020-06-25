import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:studentsocial/helpers/logging.dart';

import '../models/entities/login.dart';
import '../models/entities/schedule.dart';
import '../models/entities/semester.dart';

part 'rest_client.g.dart';

final restClient = Provider<RestClient>((ref) => RestClient.create());

@RestApi(baseUrl: 'http://171.244.38.52/api/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  factory RestClient.create() {
    final Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestHeader: false,
        requestBody: false,
        request: false));

    return RestClient(dio);
  }

  @POST('login')
  Future<LoginResult> login(@Field() String username, @Field() String password);

  @POST('semester')
  Future<SemesterResult> getSemester(@Header('token') String token);

//  Future<String> getProfile(String token) async {
//    var res =
//        await http.post(URL.GET_PROFILE, headers: {"access-token": token});
//    if (res.statusCode == 200) {
//      return res.body;
//    } else {
//      return '';
//    }
//  }

//  Future<String> getMark(String token) async {
//    var res = await http.post(URL.GET_MARK, headers: {"access-token": token});
//    if (res.statusCode == 200) {
//      return res.body;
//    } else {
//      return '';
//    }
//  }

  @POST('time-table')
  Future<ScheduleResult> getLichHoc(
      @Header('token') String token, @Field() String semester);

  //hàm này dùng cho cả get lichthilai vì đều là lịch thi (chỉ khác semester)
  @POST('exam-table')
  Future<ScheduleResult> getLichThi(
      @Header('token') String token, @Field() String semester);
}

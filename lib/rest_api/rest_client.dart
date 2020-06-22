import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/models/entities/semester.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'http://171.244.38.52/api/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  factory RestClient.create() {
    final dio = Dio();
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
  Future<List<Schedule>> getLichHoc(
      @Header('token') String token, @Field() String semester);

  //hàm này dùng cho cả get lichthilai vì đều là lịch thi (chỉ khác semester)
  @POST('exam-table')
  Future<List<Schedule>> getLichThi(
      @Header('token') String token, @Field() String semester);
}

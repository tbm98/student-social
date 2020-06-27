import 'package:http/io_client.dart';
import 'package:http/http.dart';

class GoogleHttpClient extends IOClient {
  GoogleHttpClient(this._headers) : super();

  final Map<String, String> _headers;

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

// import 'package:http/io_client.dart';
// import 'package:http/http.dart';

// class GoogleHttpClient extends IOClient {
//   Future<Map<String, String>> _headers;

//   GoogleHttpClient(this._headers) : super();

//   @override
//   Future<StreamedResponse> send(BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));

// }
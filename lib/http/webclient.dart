import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

final Client client = HttpClientWithInterceptor.build(
    interceptors: [LoggingInterceptor(),],
    requestTimeout: Duration(seconds: 5)
);

const String baseUrl = 'http://192.168.1.4:8080/transactions';
//const String baseUrl = 'http://192.168.1.5:8080/transactions'; // for tests of timeout on request http
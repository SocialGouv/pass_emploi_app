import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

class DioFakeResponse extends Fake implements Response<dynamic> {}

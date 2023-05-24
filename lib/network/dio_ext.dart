import 'package:dio/dio.dart';

extension DioResponseExt on Response<dynamic> {
  List<T> asListOf<T>(T Function(dynamic) fromJson) {
    return (data as List).map(fromJson).toList();
  }
}

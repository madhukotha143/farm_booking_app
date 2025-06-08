import 'package:dio/dio.dart';
import 'package:farm_booking_app/constants.dart';
import 'package:farm_booking_app/models/farm_house.dart';

class FarmhouseService {
  Dio getDio() {
    Dio dio = Dio();
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    return dio;
  }

  Future<List<FarmHouse>> getFarms(int vendorId) async {
    try {
      final dio = getDio();
      final response = await dio.get(
          '${Constants.baseUrl}/user/space/availability/vendor-farmhouses',
          queryParameters: {'vendor_id': vendorId});
      List<dynamic> data = response.data['farmhouses'];
      List<FarmHouse> farmhouses =
          data.map((e) => FarmHouse.fromJson(e)).toList();
      return farmhouses;
    } catch (e) {
      throw Exception('Failed to fetch farms: $e');
    }
  }
}

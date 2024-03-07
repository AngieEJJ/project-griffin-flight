import 'package:griffin/data/dtos/airport_dto.dart';

import '../../data/core/result.dart';
import '../model/airport_model.dart';

abstract interface class AirportRepository {
  Future<Result<List<AirportModel>>> getAirportData();
  Future<Result<List<AirportDTO>>> getAirportListData();
}
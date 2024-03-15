import 'package:griffin/domain/model/flight_result/flight_result_model.dart';
import 'package:griffin/domain/repositories/flight_repository.dart';

class GetFromFlightUseCase {
  GetFromFlightUseCase({
    required FlightRepository flightRepository,
  }) : _flightRepository = flightRepository;
  final FlightRepository _flightRepository;

  Future<FlightResultModel> execute() async {
    final result = await _flightRepository.getSearchFlightResult('from_flight');

    return result.when(
      success: (data) => data,
      error: (message) => throw Exception(message),
    );
  }
}
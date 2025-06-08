import 'package:farm_booking_app/models/farm_house.dart';
import 'package:farm_booking_app/services/auth_service.dart';
import 'package:farm_booking_app/services/farmhouse_service.dart';
import 'package:flutter/foundation.dart';

class HomeScreenProvider with ChangeNotifier {
  final FarmhouseService _farmhouseService = FarmhouseService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<FarmHouse> _farmHouses = [];

  FarmHouse? _selectedFarmHouse;
  FarmHouse? get selectedFarmHouse => _selectedFarmHouse;

  List<FarmHouse> get farmHouses => _farmHouses;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    notifyListeners();
  }

  void setSelectedFarmHouse(FarmHouse? value) {
    _selectedFarmHouse = value;
    notifyListeners();
  }

  void fetchFarmHouses() async {
    setLoading(true);
    try {
      final user = await AuthService().getUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }
      final response = await _farmhouseService.getFarms(user.id);
      _farmHouses.clear();
      _farmHouses.addAll(response);

      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
    setLoading(false);
  }
}

import 'package:flutter/material.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/constant/linkapi.dart';

class SeatSelectionProvider extends ChangeNotifier {
  Map<int, String> selectedSeats = {};
  Map<int, String> reservedSeatsFromApi = {};
  static const int maxSeatsPerPerson = 4;
  final Crud _crud = Crud();

  void selectSeat(BuildContext context, int seatNumber, String gender) {
    if (selectedSeats.length >= maxSeatsPerPerson) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("4'ten fazla koltuk rezerve edemezsiniz!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (reservedSeatsFromApi.containsKey(seatNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bu koltuk zaten rezerve edilmiş!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    selectedSeats[seatNumber] = gender;
    notifyListeners();
  }

  void removeSeat(int seatNumber) {
    selectedSeats.remove(seatNumber);
    notifyListeners();
  }

  void clearSelections() {
    selectedSeats.clear();
    notifyListeners();
  }

  Future<void> loadSeatsFromApi(int busId, int tripId) async {
    final response = await _crud.postRequest(linkSeatsGet, {
      "bus_id": busId.toString(),
      "trip_id": tripId.toString(),
    });

    print("API response: $response");

    if (response != null && response['status'] == 'success') {
      final List data = response['data'];
      reservedSeatsFromApi.clear();

      for (var seat in data) {
        if (seat['is_available'] == false ||
            seat['is_available'].toString() == 'false') {
          int seatNumber = int.tryParse(seat['seat_number'].toString()) ?? -1;
          if (seatNumber != -1) {
            String gender = seat['gender'] ?? '';
            reservedSeatsFromApi[seatNumber] = gender;
          }
        }
      }
      notifyListeners();
    } else {
      print("Failed to load seats or no data found");
    }
  }

  Future<void> saveSelections(
      BuildContext context, int busId, int tripId) async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen en az bir koltuk seçin!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (var entry in selectedSeats.entries) {
      int seatNumber = entry.key;
      String gender = entry.value;

      final response = await _crud.postRequest(linkSeatAdd, {
        "bus_id": busId.toString(),
        "trip_id": tripId.toString(),
        "seat_number": seatNumber.toString(),
        "gender": gender,
      });

      if (response == null || response['status'] != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Koltuk $seatNumber kaydedilemedi."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    clearSelections();
    await loadSeatsFromApi(busId, tripId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Seçilen koltuklar başarıyla kaydedildi."),
        backgroundColor: Colors.green,
      ),
    );
  }
}

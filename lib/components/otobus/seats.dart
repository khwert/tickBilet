import 'package:flutter/material.dart';
import 'package:ticketproject/components/otobus/seat.dart';
import 'package:provider/provider.dart';
import 'package:ticketproject/components/provider/seat_prov.dart';

class Seats extends StatefulWidget {
  final int seatsLRB;
  final int crossAxisCount;
  final int seatIndex;
  final double height;
  final int busId;
  final int tripId;
  const Seats({
    super.key,
    required this.seatsLRB,
    required this.crossAxisCount,
    required this.height,
    required this.seatIndex,
    required this.busId,
    required this.tripId,
  });

  @override
  State<Seats> createState() => _SeatsState();
}

class _SeatsState extends State<Seats> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() {
  //     Provider.of<SeatSelectionProvider>(context, listen: false)
  //         .loadSeatsFromApi(widget.busId, widget.tripId);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<SeatSelectionProvider>(context, listen: false);
      provider.loadSeatsFromApi(widget.busId, widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    void showGenderDialog(int seatNumber) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cinsiyet Seçin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.male, color: Color(0xFF4A90E2)),
                  title: const Text('Erkek'),
                  onTap: () {
                    Provider.of<SeatSelectionProvider>(context, listen: false)
                        .selectSeat(context, seatNumber, 'male');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.female, color: Color(0xFFE74C88)),
                  title: const Text('Kadın'),
                  onTap: () {
                    Provider.of<SeatSelectionProvider>(context, listen: false)
                        .selectSeat(context, seatNumber, 'female');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    int globalIndex = widget.seatIndex;
    return SizedBox(
      height: widget.height,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: 0.82,
        children: List.generate(widget.seatsLRB, (index) {
          int seatNumber = globalIndex + index;
          final seatProvider = Provider.of<SeatSelectionProvider>(context);
          final bool isOccupiedByUser =
              seatProvider.selectedSeats.containsKey(seatNumber);
          final bool isReservedByApi =
              seatProvider.reservedSeatsFromApi.containsKey(seatNumber);

          Color seatColor;

          if (isOccupiedByUser) {
            seatColor = const Color(0xFF4CAF50);
          } else if (isReservedByApi) {
            String gender = seatProvider.reservedSeatsFromApi[seatNumber] ?? '';
            seatColor = gender == 'male'
                ? const Color(0xFF4A90E2)
                : const Color(0xFFE74C88);
          } else {
            seatColor = Colors.white;
          }

          return InkWell(
            onTap: isOccupiedByUser
                ? () {
                    seatProvider.removeSeat(seatNumber);
                  }
                : () => showGenderDialog(seatNumber),
            child: seat(seatNumber, seatColor),
          );
        }),
      ),
    );
  }
}

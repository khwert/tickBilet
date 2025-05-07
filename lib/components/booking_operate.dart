import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketproject/components/otobus/seat.dart';
import 'package:ticketproject/components/provider/seat_prov.dart';
import 'package:ticketproject/constant/colors.dart';

class BookingOperate extends StatelessWidget {
  final double price;
  final Function()? onPressed;
  const BookingOperate({super.key, required this.price, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<SeatSelectionProvider>(
      builder: (context, seatProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Seçtiğiniz Koltuklar:",
              style: TextStyle(
                  color: secondaryTextColor, fontWeight: FontWeight.w500),
            ),
            Row(
              children: seatProvider.selectedSeats.entries.map(
                (entry) {
                  Color seatColor =
                      entry.value == 'male' ? Colors.blue : Colors.pink;
                  return SizedBox(
                    height: 40,
                    width: 40,
                    child: seat(entry.key, seatColor),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 50),
            const Text(
              "Toplam Fiyat:",
              style: TextStyle(
                  color: secondaryTextColor, fontWeight: FontWeight.w500),
            ),
            Text(
              "${seatProvider.selectedSeats.length * price} TL",
              style: const TextStyle(
                color: secondaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: interactiveColor,
              ),
              child: const Text(
                "ONAYLA VE DEVAM ET",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ticketproject/components/otobus/seat.dart';

class ErkekKadin extends StatelessWidget {
  const ErkekKadin({super.key});

  @override
  Widget build(BuildContext context) {
    List seatInfo = [
      "Dolu Koltuk - Erkek",
      "Dolu Koltuk - Kadın",
      "Boş Koltuk",
      "Seçilen Koltuk"
    ];
    List seatColor = [
      const Color(0xFF4A90E2),
      const Color(0xFFE74C88),
      Colors.white,
      const Color(0xFF2ECC71)
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
          children: seatInfo
              .asMap()
              .map((index, bilgi) => MapEntry(
                  index,
                  Row(children: [
                    SizedBox(
                        height: 30,
                        width: 35,
                        child: seat(0, seatColor[index])),
                    Text(bilgi, style: const TextStyle(fontSize: 16))
                  ])))
              .values
              .toList()),
    );
  }
}

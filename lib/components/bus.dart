import 'package:company_dashboard/components/buttons/custombutton.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:flutter/material.dart';

Widget theBus(
    int sayi, String platenumber, String totalseats, Function()? onTap) {
  return Card(
    margin: const EdgeInsets.only(right: 200, bottom: 10),
    color: mainColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 350,
            child: Row(
              children: [
                Text(
                  sayi.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 20),
                  child: Icon(
                    Icons.directions_bus_filled,
                    color: Colors.white54,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Plaka Numarası:  ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: platenumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 350,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.event_seat,
                    color: Colors.white54,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Toplam Koltuk Sayısı:  ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: totalseats,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          customButton(
              onTap,
              const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
              "Otobüs Sil",
              Colors.red,
              mainColor),
        ],
      ),
    ),
  );
}

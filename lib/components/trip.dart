import 'package:company_dashboard/components/buttons/custombutton.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:flutter/material.dart';

Widget theTrip(
  int sayi,
  String departureCity,
  String arrivalCity,
  String departureTime,
  String arrivalTime,
  String price,
  String busId,
  Function()? onTap,
) {
  return Card(
    margin: const EdgeInsets.only(left: 200, bottom: 10),
    color: mainColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$sayi. Sefer",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white54),
              const SizedBox(width: 10),
              const Text(
                "Kalkış: ",
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
              Text(
                departureCity,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(width: 30),
              const Icon(Icons.flag, color: Colors.white54),
              const SizedBox(width: 10),
              const Text(
                "Varış: ",
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
              Text(
                arrivalCity,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text(
                    "Kalkış Zamanı: ",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  Text(
                    departureTime,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  const Icon(Icons.schedule_outlined, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text(
                    "Varış Zamanı: ",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  Text(
                    arrivalTime,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text(
                    "Fiyat: ",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  Text(
                    "$price ₺",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  const Icon(Icons.directions_bus, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text(
                    "Otobüs ID: ",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  Text(
                    busId,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: customButton(
              onTap,
              const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
              "Seferi Sil",
              Colors.red,
              mainColor,
            ),
          ),
        ],
      ),
    ),
  );
}

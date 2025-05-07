import 'package:flutter/material.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/components/otobus/seats.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/constant/linkapi.dart';

class Bus extends StatefulWidget {
  final int busid;
  final int companyid;
  final int tripId;
  const Bus(
      {super.key,
      required this.busid,
      required this.companyid,
      required this.tripId});

  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
  final Crud _crud = Crud();
  Future getBusData() async {
    var response = await _crud.postRequest(linkBusGet, {
      "bus_id": widget.busid.toString(),
      "company_id": widget.companyid.toString(),
    });
    return response;
  }

  @override
  void initState() {
    super.initState();
    loadBusData();
  }

  bool isLoading = true;
  int totalSeats = 0;

  void loadBusData() async {
    var response = await getBusData();
    if (response['status'] == 'success') {
      var data = response['data'];
      setState(() {
        totalSeats = int.parse(data['total_seats'].toString());
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    int seatsL = (totalSeats / 3).floor(); //8
    int seatsR = (totalSeats / 1.5).floor();
    int seatB = totalSeats - (seatsL + seatsR);

    int seatIndexL = 1;
    int seatIndexR = seatsL + 1;
    int seatIndexB = seatsL + seatsR + 1;
    return Container(
      margin: const EdgeInsets.only(left: 60, bottom: 30, top: 30),
      padding: const EdgeInsets.only(right: 21),
      decoration: BoxDecoration(
          color: generalBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0.5,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(50, 30),
            bottomLeft: Radius.elliptical(50, 30),
            bottomRight: Radius.elliptical(10, 50),
            topRight: Radius.elliptical(10, 50),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Opacity(
              opacity: 0.5,
              child: Transform.rotate(
                angle: -1.5,
                child: Image.asset(
                  'assets/steering.png',
                  height: 45,
                  width: 45,
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            height: 90,
            margin: const EdgeInsets.only(left: 5, right: 12),
            color: const Color(0xFFD9D9D9),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Seats(
                    crossAxisCount: 2,
                    seatsLRB: seatsR,
                    height: 80,
                    seatIndex: seatIndexR,
                    busId: widget.busid,
                    tripId: widget.tripId,
                  ),
                ),
                Row(
                  children: [
                    const Spacer(flex: 12),
                    Flexible(
                      flex: 1,
                      child: Seats(
                        crossAxisCount: 2,
                        height: 80,
                        seatIndex: seatIndexB,
                        seatsLRB: seatB,
                        busId: widget.busid,
                        tripId: widget.tripId,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Seats(
                    crossAxisCount: 1,
                    seatsLRB: seatsL,
                    height: 40,
                    seatIndex: seatIndexL,
                    busId: widget.busid,
                    tripId: widget.tripId,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

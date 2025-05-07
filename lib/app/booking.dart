import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/app/booking_details.dart';
import 'package:ticketproject/components/booking_operate.dart';
import 'package:ticketproject/components/home/app_bar.dart';
import 'package:ticketproject/components/my_text_button.dart';
import 'package:ticketproject/components/otobus/bus.dart';
import 'package:ticketproject/components/otobus/erkek_kadin.dart';
import 'package:ticketproject/components/provider/seat_prov.dart';
import 'package:ticketproject/components/time_func.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/constant/linkapi.dart';

class Booking extends StatefulWidget {
  final int? departureCityId;
  final int? arrivalCityId;
  final DateTime? selectedDate;
  final int? userID;
  const Booking({
    super.key,
    this.departureCityId,
    this.arrivalCityId,
    this.selectedDate,
    this.userID,
  });

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final Crud _crud = Crud();
  getTrips() async {
    var response = await _crud.postRequest(linkTripsList, {
      "departure_city_id": widget.departureCityId.toString(),
      "arrival_city_id": widget.arrivalCityId.toString(),
      "departure_time": widget.selectedDate!.toIso8601String().split('T').first
    });
    return response;
  }

  List<bool> isExpandedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/kirsehiroto.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            kIsWeb
                ? const CustomAppBarForWeb()
                : const CustomAppBar(
                    homeControl: 'no',
                  ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getTrips(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data['status'] == 'fail') {
                        return const Center(
                          child: Text(
                            "Sefer Bulonmiyor",
                            style: TextStyle(
                                fontSize: 25,
                                color: primaryTextColor,
                                backgroundColor: generalBackgroundColor),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: (context, index) {
                          var trip = snapshot.data['data'][index];
                          String departureTime = trip['departure_time'];
                          String arrivalTime = trip['arrival_time'];

                          String timePeriod = calculateTimeDifference(
                              departureTime, arrivalTime);

                          if (isExpandedList.length <= index) {
                            isExpandedList.add(false);
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: generalBackgroundColor.withOpacity(0.7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0.5,
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.network(
                                        "$linkLogoRoot/${trip['logo']}",
                                        height: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset('assets/bus.png',
                                              height: 80);
                                        },
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 4, right: 4),
                                                child: Icon(
                                                  Icons
                                                      .access_time_filled_rounded,
                                                  color: secondaryTextColor,
                                                  size: 21,
                                                ),
                                              ),
                                              Text(
                                                formatTime(
                                                    trip['departure_time']),
                                                style: const TextStyle(
                                                  color: primaryTextColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            timePeriod,
                                            style: const TextStyle(
                                              color: secondaryTextColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${trip['price']} ₺",
                                        style: const TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      myTextButton(() {
                                        setState(() {
                                          bool isCurrentlyExpanded =
                                              isExpandedList[index];

                                          for (int i = 0;
                                              i < isExpandedList.length;
                                              i++) {
                                            isExpandedList[i] = false;
                                          }

                                          if (!isCurrentlyExpanded) {
                                            isExpandedList[index] = true;
                                          }

                                          Provider.of<SeatSelectionProvider>(
                                                  context,
                                                  listen: false)
                                              .clearSelections();
                                        });
                                      },
                                          const EdgeInsets.all(8),
                                          isExpandedList[index]
                                              ? "KAPAT"
                                              : "KOLTUK SEÇ",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          5),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: generalBackgroundColor,
                                  height: 0,
                                ),
                                !isExpandedList[index]
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            bool isCurrentlyExpanded =
                                                isExpandedList[index];

                                            for (int i = 0;
                                                i < isExpandedList.length;
                                                i++) {
                                              isExpandedList[i] = false;
                                            }

                                            if (!isCurrentlyExpanded) {
                                              isExpandedList[index] = true;
                                            }

                                            Provider.of<SeatSelectionProvider>(
                                                    context,
                                                    listen: false)
                                                .clearSelections();
                                          });
                                        },
                                        style: ButtonStyle(
                                          overlayColor: WidgetStateProperty.all(
                                              Colors.transparent),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_drop_down_circle_outlined,
                                              color: secondaryTextColor,
                                              size: 20,
                                            ),
                                            Text(
                                              "İncele",
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const Text(""),

                                //    BUS SHOW ///
                                isExpandedList[index]
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Bus(
                                                  tripId: trip['trip_id'],
                                                  busid: trip['bus_id'],
                                                  companyid: trip['company_id'],
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 80),
                                                  child: ErkekKadin(),
                                                )
                                              ],
                                            ),
                                          ),
                                          // devider
                                          Container(
                                            width: 2,
                                            height: 300,
                                            margin: const EdgeInsets.only(
                                                left: 110, right: 12),
                                            color: const Color(0xFFD9D9D9),
                                          ),
                                          BookingOperate(
                                            price: double.tryParse(
                                                    trip['price'].toString()) ??
                                                0,
                                            onPressed: () async {
                                              // int busId = trip['bus_id'];
                                              // int tripId = trip['trip_id'];

                                              final seatSelectionProvider =
                                                  Provider.of<
                                                          SeatSelectionProvider>(
                                                      context,
                                                      listen: false);

                                              // if (seatSelectionProvider
                                              //     .selectedSeats.isEmpty) {
                                              //   ScaffoldMessenger.of(context)
                                              //       .showSnackBar(
                                              //     const SnackBar(
                                              //       content: Text(
                                              //           "Koltuklar kaydedilmedi!"),
                                              //       backgroundColor: Colors.red,
                                              //     ),
                                              //   );
                                              //   return;
                                              // }

                                              // نقوم بتهيئة البيانات وننتقل إلى صفحة التفاصيل بدون حفظ في القاعدة
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      BookingDetails(
                                                    tripDetails: {
                                                      ...trip,
                                                      "user_id": widget
                                                          .userID, // نمرر user_id مع التفاصيل
                                                    },
                                                    selectedSeats:
                                                        seatSelectionProvider
                                                            .selectedSeats
                                                            .entries
                                                            .map((entry) {
                                                      return {
                                                        "seat_number": entry.key
                                                            .toString(),
                                                        "gender": entry.value,
                                                      };
                                                    }).toList(),
                                                    timePeriod: timePeriod,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          const SizedBox(
                                            width: 50,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const Center();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

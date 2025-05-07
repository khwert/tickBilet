import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/components/home/app_bar.dart';
import 'package:ticketproject/components/provider/seat_prov.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/constant/linkapi.dart';
import 'package:ticketproject/main.dart';

class BookingDetails extends StatefulWidget {
  final Map<String, dynamic> tripDetails;
  final List<Map<String, String>> selectedSeats;
  final String timePeriod;
  const BookingDetails({
    super.key,
    required this.tripDetails,
    required this.selectedSeats,
    required this.timePeriod,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _idControllers = [];

  final Crud _crud = Crud();
  @override
  void initState() {
    super.initState();
    _initializeControllersAndFillUserName();
  }

  void _initializeControllersAndFillUserName() async {
    String? userName = sharedPref.getString("name");

    for (int i = 0; i < widget.selectedSeats.length; i++) {
      _nameControllers.add(TextEditingController());
      _idControllers.add(TextEditingController());
    }

    if (userName != null && _nameControllers.isNotEmpty) {
      _nameControllers[0].text = userName;
    }

    setState(() {});
  }

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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kIsWeb
                    ? const CustomAppBarForWeb()
                    : const CustomAppBar(
                        homeControl: 'no',
                      ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Card(
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sefer Bilgileri",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Kalkış Şehri: ${widget.tripDetails['departure_city']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Varış Şehri: ${widget.tripDetails['arrival_city']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Kalkış Saati: ${widget.tripDetails['departure_time']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Varış Saati: ${widget.tripDetails['arrival_time']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Süre: ${widget.timePeriod}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Fiyat: ${widget.tripDetails['price']} ₺",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Sefer Belgeler: Kimlik veya pasaport gereklidir.",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Card(
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Yolcu Bilgileri",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.selectedSeats.length,
                                  itemBuilder: (context, index) {
                                    var seat = widget.selectedSeats[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Koltuk: ${seat['seat_number']} (${seat['gender']})",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: _nameControllers[index],
                                          decoration: const InputDecoration(
                                            labelText: "Yolcu Adı",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Lütfen yolcu adını girin";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: _idControllers[index],
                                          decoration: const InputDecoration(
                                            labelText: "Kimlik Numarası",
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Lütfen kimlik numarasını girin";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        final seatSelectionProvider =
                            Provider.of<SeatSelectionProvider>(context,
                                listen: false);

                        int busId = widget.tripDetails['bus_id'];
                        int tripId = widget.tripDetails['trip_id'];

                        var firstEntry =
                            seatSelectionProvider.selectedSeats.entries.first;
                        int seatNumber = firstEntry.key;

                        var responseBooking =
                            await _crud.postRequest(linkBooking, {
                          "user_id": widget.tripDetails['user_id'].toString(),
                          "trip_id": tripId.toString(),
                          "booking_date": DateTime.now().toIso8601String(),
                          "seat_number": seatNumber.toString(),
                        });

                        if (responseBooking['status'] != 'success') {
                          String errorMessage = responseBooking['message'] ??
                              "Rezervasyon başarısız oldu!";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        } else {
                          await seatSelectionProvider.saveSelections(
                              context, busId, tripId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Rezervasyon başarıyla tamamlandı!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: interactiveColor,
                      ),
                      child: const Text(
                        "Rezervasyonu Onayla",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

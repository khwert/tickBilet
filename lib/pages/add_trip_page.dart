import 'package:company_dashboard/components/buttons/arrival_time_select_button.dart';
import 'package:company_dashboard/components/buttons/bus_select_button.dart';
import 'package:company_dashboard/components/buttons/buttontext.dart';
import 'package:company_dashboard/components/buttons/city_select_bottun.dart';
import 'package:company_dashboard/components/customtextform.dart';
import 'package:company_dashboard/components/departure_time_select_bottun.dart';
import 'package:company_dashboard/constant/city_list_hide.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:company_dashboard/main.dart';
import 'package:flutter/material.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController priceController = TextEditingController();
  final Crud _crud = Crud();
  GlobalKey<FormState> formstate = GlobalKey();
  final GlobalKey<DepartureTimeSelectButtonState> departureKey = GlobalKey();
  final GlobalKey<ArrivalTimeSelectButtonState> arrivalKey = GlobalKey();

  addTrip() async {
    if (formstate.currentState!.validate()) {
      DateTime departureTime = departureKey.currentState!.getCombinedDateTime();
      DateTime arrivalTime = arrivalKey.currentState!.getCombinedDateTime();

      var response = await _crud.postRequest(linkAddTrip, {
        "company_id": sharedPref.getString("company_id"),
        "departure_city_id": departureCityId.toString(),
        "arrival_city_id": arrivalCityId.toString(),
        "departure_time": departureTime.toIso8601String(),
        "arrival_time": arrivalTime.toIso8601String(),
        "price": priceController.text,
        "bus_id": busID.toString(),
      });

      if (response['status'] == "success") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("dashboard", (route) => false);
      } else {
        // show error
      }
    }
  }

  int? departureCityId;
  int? arrivalCityId;

  List<Map<String, dynamic>> cities = [];

  int? busID;
  List<Map<String, dynamic>> buses = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadBuses();
  }

  void _loadCities() async {
    final response = await _crud.getRequest(linkCiteisView);
    if (response != null && response['status'] == 'success') {
      setState(() {
        cities = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  void _loadBuses() async {
    final response = await _crud.postRequest(
        linkListBus, {"company_id": sharedPref.getString("company_id")});
    if (response != null && response['status'] == 'success') {
      setState(() {
        buses = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sefer Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            hideOverlay();
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formstate,
        child: GestureDetector(
          onTap: hideOverlay,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CitySellectButton(
                                top: "Nereden",
                                middle: departureCityId == null
                                    ? "Şehir Seç"
                                    : cities.firstWhere((c) =>
                                        c['city_id'] ==
                                        departureCityId)['name'],
                                onCitySelected: (id, name) {
                                  setState(() => departureCityId = id);
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            CitySellectButton(
                                top: "Nereye",
                                middle: arrivalCityId == null
                                    ? "Şehir Seç"
                                    : cities.firstWhere((c) =>
                                        c['city_id'] == arrivalCityId)['name'],
                                onCitySelected: (id, name) {
                                  setState(() => arrivalCityId = id);
                                }),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              BusSellectButton(
                                top: "Otobüs Seç",
                                middle: busID == null
                                    ? "Plaka"
                                    : buses.firstWhere((c) =>
                                        c['bus_id'] == busID)['plate_number'],
                                onBusSelected: (id, plate) {
                                  setState(() => busID = id);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 60,
                                width: 310,
                                child: CustomTextForm(
                                  hint: 'Fiyat',
                                  icon: const Icon(
                                    Icons.attach_money_rounded,
                                    color: Color.fromARGB(255, 11, 76, 156),
                                  ),
                                  mycontroller: priceController,
                                  keyboardType: TextInputType.number,
                                  valida: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Fiyat zorunludur'; // السعر مطلوب
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        DepartureTimeSelectButton(key: departureKey),
                        const SizedBox(
                          width: 10,
                        ),
                        ArrivalTimeSelectButton(key: arrivalKey),
                      ],
                    ),
                    const Divider(
                      color: mainColor,
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: (arrivalCityId != null &&
                              departureCityId != null &&
                              busID != null)
                          ? textbutton(() {
                              addTrip();
                            }, 'Kaydet ✓', mainColor)
                          : textbutton(() {}, 'Kaydet ✓', Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

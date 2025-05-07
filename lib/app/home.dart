import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/app/booking.dart';
import 'package:ticketproject/components/home/app_bar.dart';
import 'package:ticketproject/components/home/city_select_bottun.dart';
import 'package:ticketproject/components/home/time_select_bottun.dart';
import 'package:ticketproject/components/my_text_button.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/constant/city_list.dart';
import 'package:ticketproject/constant/linkapi.dart';
import 'package:ticketproject/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Crud _crud = Crud();
  String? userID;
  int? departureCityId;
  int? arrivalCityId;
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> cities = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
    loadUserData();
  }

  void _loadCities() async {
    final response = await _crud.getRequest(linkCiteisView);
    if (response != null && response['status'] == 'success') {
      setState(() {
        cities = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  getUser() async {
    var response = await _crud.postRequest(linkLogin, {
      "email": sharedPref.getString("email"),
      "password_hash": sharedPref.getString("password_hash")
    });
    return response;
  }

  void loadUserData() async {
    var response = await getUser();
    if (response['status'] == 'success') {
      var data = response['data'];
      setState(() {
        userID = data['user_id'].toString();
      });
    }
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
        child: Column(
          children: [
            kIsWeb
                ? const CustomAppBarForWeb()
                : const CustomAppBar(
                    homeControl: 'home',
                  ),
            Card(
              margin: const EdgeInsets.only(left: 100, right: 100, top: 80),
              color: generalBackgroundColor.withOpacity(0.9),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CitySellectButton(
                          top: "Nereden",
                          middle: departureCityId == null
                              ? "İstanbul"
                              : cities.firstWhere((c) =>
                                  c['city_id'] == departureCityId)['name'],
                          onCitySelected: (id, name) {
                            setState(() => departureCityId = id);
                          }),
                      CitySellectButton(
                          top: "Nereye",
                          middle: arrivalCityId == null
                              ? "Ankara"
                              : cities.firstWhere(
                                  (c) => c['city_id'] == arrivalCityId)['name'],
                          onCitySelected: (id, name) {
                            setState(() => arrivalCityId = id);
                          }),
                      TimeSelectButton(
                        onDateSelected: (date) {
                          selectedDate = date;
                        },
                      ),
                      myTextButton(() {
                        hideOverlay();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Booking(
                              //userName: userName ?? '',
                              userID: int.tryParse(userID!),
                              departureCityId: departureCityId ?? 34,
                              arrivalCityId: arrivalCityId ?? 6,
                              selectedDate: selectedDate, // ⬅️ أضف هذا
                            );
                          },
                        ));
                      },
                          const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 20),
                          "Otobüs Ara",
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          20),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

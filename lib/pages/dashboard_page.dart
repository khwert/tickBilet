import 'package:company_dashboard/components/ball_contaner.dart';
import 'package:company_dashboard/components/bus.dart';
import 'package:company_dashboard/components/buttons/custombutton.dart';
import 'package:company_dashboard/components/trip.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:company_dashboard/main.dart';
import 'package:company_dashboard/pages/add_bus_page.dart';
import 'package:company_dashboard/pages/add_trip_page.dart';
import 'package:company_dashboard/pages/edit_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Crud crud = Crud();
  String? logoName;
  bool hasBuses = false;
  bool hasTrips = false;
  bool gosterButton = false; // false -> otobus // true -> sefer
  getCopmany() async {
    var response = await crud.postRequest(
        linkCompGit, {"company_id": sharedPref.getString("company_id")});
    return response;
  }

  @override
  void initState() {
    super.initState();
    loadCompanyData();
    checkBusesAndTrips();
  }

  void loadCompanyData() async {
    var response = await getCopmany();
    if (response['status'] == 'success') {
      var data = response['data'];
      setState(() {
        logoName = data['logo'];
      });
    }
  }

  Future<void> checkBusesAndTrips() async {
    String? companyId = sharedPref.getString("company_id");

    // تحقق من الباصات
    var busResponse =
        await crud.postRequest(linkListBus, {"company_id": companyId});
    if (busResponse['status'] == 'success' && busResponse['data'].isNotEmpty) {
      hasBuses = true;
    }

    // تحقق من الرحلات
    var tripResponse =
        await crud.postRequest(linkListTrips, {"company_id": companyId});
    if (tripResponse['status'] == 'success' &&
        tripResponse['data'].isNotEmpty) {
      hasTrips = true;
    }

    setState(() {});
  }

  getListBus() async {
    var response = await crud.postRequest(
        linkListBus, {"company_id": sharedPref.getString("company_id")});
    return response;
  }

  getListTrips() async {
    var response = await crud.postRequest(
        linkListTrips, {"company_id": sharedPref.getString("company_id")});
    return response;
  }

  deleteBus(String busID) async {
    setState(() {});
    var response = await crud.postRequest(linkDeleteBus, {"bus_id": busID});
    return response;
  }

  deleteTrip(String tripID) async {
    setState(() {});
    var response = await crud.postRequest(linkDeleteTrip, {"trip_id": tripID});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Yönetim Paneli - ",
                style: TextStyle(
                  fontSize: 22,
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: sharedPref.getString("company_name"),
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          customButton(
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddBusPage())),
              Image.asset(
                'assets/addbus.png',
                color: Colors.white,
                height: 20,
              ),
              "Otobüs Ekle",
              Colors.white,
              mainColor),
          customButton(
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddTripPage())),
              Image.asset(
                'assets/addtrip.png',
                color: Colors.white,
                height: 20,
              ),
              "Sefer Ekle",
              Colors.white,
              mainColor),
          customButton(() {
            sharedPref.clear();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("login", (route) => false);
          },
              const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20,
              ),
              "Çıkış",
              Colors.white,
              mainColor),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.grey,
                    child: (logoName == null || logoName!.isEmpty)
                        ? Image.asset('assets/busicon.png', height: 80)
                        : Image.network(
                            "$linkLogoRoot/$logoName",
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/busicon.png',
                                  height: 80);
                            },
                          ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  customButton(
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EditCompanyPage())),
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      "Şirket Bilgilerini Düzenle",
                      Colors.white,
                      mainColor),
                ],
              ),
              const Divider(
                height: 50,
              ),
              if (hasBuses && hasTrips)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        customButton(() {
                          gosterButton = false;
                          setState(() {});
                        },
                            const Icon(
                              Icons.directions_bus_filled,
                              color: Colors.white,
                              size: 20,
                            ),
                            " Otobüsleri Göster  ",
                            Colors.white,
                            gosterButton ? Colors.grey : mainColor),
                        ballContainer(gosterButton ? Colors.white : mainColor),
                      ],
                    ),
                    Column(
                      children: [
                        customButton(() {
                          gosterButton = true;
                          setState(() {});
                        },
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            " Seferleri Göster   ",
                            Colors.white,
                            gosterButton ? mainColor : Colors.grey),
                        ballContainer(gosterButton ? mainColor : Colors.white),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButton(
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddBusPage())),
                        Image.asset(
                          'assets/addbus.png',
                          color: Colors.white,
                          height: 20,
                        ),
                        "Otobüs Ekle",
                        Colors.white,
                        mainColor),
                    customButton(
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddTripPage())),
                        Image.asset(
                          'assets/addtrip.png',
                          color: Colors.white,
                          height: 20,
                        ),
                        "Sefer Ekle",
                        Colors.white,
                        mainColor),
                    const Text(
                      "Tıklayıp Otobüs ve Sefer Ekleyin",
                      style: TextStyle(color: mainColor, fontSize: 20),
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: FutureBuilder(
                    future: gosterButton ? getListTrips() : getListBus(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['status'] == 'fail') {
                          return Text(
                            gosterButton
                                ? "Sefer Bulunmiyor"
                                : "Otobüs Bulunmiyor",
                            style: const TextStyle(fontSize: 25),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data['data'].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return gosterButton
                                ? theTrip(
                                    index + 1,
                                    snapshot.data['data'][index]
                                            ['departure_city_name'] ??
                                        '',
                                    snapshot.data['data'][index]
                                            ['arrival_city_name'] ??
                                        '',
                                    snapshot.data['data'][index]
                                            ['departure_time'] ??
                                        '',
                                    snapshot.data['data'][index]
                                            ['arrival_time'] ??
                                        '',
                                    snapshot.data['data'][index]['price'] ?? '',
                                    snapshot.data['data'][index]
                                            ['plate_number'] ??
                                        '',
                                    () => deleteTrip(snapshot.data['data']
                                            [index]['trip_id']
                                        .toString()),
                                  )
                                : theBus(
                                    index + 1,
                                    snapshot.data['data'][index]
                                        ['plate_number'],
                                    snapshot.data['data'][index]['total_seats']
                                        .toString(), () {
                                    deleteBus(snapshot.data['data'][index]
                                            ['bus_id']
                                        .toString());
                                  });
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Yukleniyor ..."),
                        );
                      }
                      return const Center(
                        child: Text("Yukleniyor ..."),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

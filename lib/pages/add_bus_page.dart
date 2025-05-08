import 'package:company_dashboard/components/buttons/buttontext.dart';
import 'package:company_dashboard/components/customtextform.dart';
import 'package:company_dashboard/components/func/valid.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:company_dashboard/main.dart';
import 'package:flutter/material.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController totalSeatsController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

  Crud crud = Crud();
  addBus() async {
    if (_formKey.currentState!.validate()) {
      var response = await crud.postRequest(linkAddBus, {
        "company_id": sharedPref.getString("company_id"),
        "total_seats": totalSeatsController.text.toString(),
        "plate_number": plateNumberController.text,
      });
      if (response['status'] == "success") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("dashboard", (route) => false);
      } else {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Otobüs Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Otobüs Bilgileri",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                        hint: 'Plaka Numarası',
                        icon: const Icon(Icons.directions_bus_filled),
                        mycontroller: plateNumberController,
                        valida: (val) {
                          return validInput(val!, 6, 8);
                        },
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: CustomTextForm(
                        hint: 'Toplam Koltuk Sayısı',
                        keyboardType: TextInputType.number,
                        icon: const Icon(Icons.event_seat),
                        mycontroller: totalSeatsController,
                        valida: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          }
                          final number = int.tryParse(val);
                          if (number == null) {
                            return 'Lütfen geçerli bir sayı girin';
                          }
                          if (number < 38 || number > 40) {
                            return 'Koltuk sayısı 38 ile 40 arasında olmalıdır';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: mainColor,
                  height: 30,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: textbutton(() {
                    addBus();
                  }, 'Kaydet ✓', mainColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:company_dashboard/components/buttons/buttontext.dart';
import 'package:company_dashboard/components/customtextform.dart';
import 'package:company_dashboard/components/func/valid.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:company_dashboard/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  Crud crud = Crud();
  bool isYukleniyor = false;

  login() async {
    if (formstate.currentState!.validate()) {
      isYukleniyor = true;
      setState(() {});

      var response = await crud.postRequest(
          linkLogin, {'username': username.text, 'password': password.text});

      isYukleniyor = false;
      setState(() {});

      if (response == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Uyarı",
          desc: "Bağlantı hatası mesajı gösteriliyor",
          btnCancel: const Text("İptal"),
          btnOk: const Text("Tamam"),
        ).show();

        return;
      }

      if (response['status'] == "success") {
        sharedPref.setString(
            "company_id", response['data']['company_id'].toString());
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("company_name", response['data']['company_name']);
        sharedPref.setString("password", response['data']['password']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("dashboard", (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: "Uyarı",
          body: const Text(
            "E-posta veya şifre yanlış. Lütfen bilgilerinizi kontrol edip tekrar deneyin.",
            style: TextStyle(fontSize: 16),
          ),
          btnCancel: const Text("Tamam"),
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isYukleniyor == true
                ? const CircularProgressIndicator()
                : Container(
                    width: 500,
                    margin: const EdgeInsets.only(left: 150),
                    child: Form(
                      key: formstate,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Şirket Girişi',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          CustomTextForm(
                            mycontroller: username,
                            hint: 'Kullanıcı Adı',
                            keyboardType: TextInputType.name,
                            valida: (val) {
                              return validInput(val!, 5, 50);
                            },
                            icon: const Icon(Icons.person),
                          ),
                          CustomTextForm(
                            mycontroller: password,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            hint: 'Şifre',
                            valida: (val) {
                              return validInput(val!, 6, 30);
                            },
                            icon: const Icon(Icons.lock),
                         
                          ),



















                          const SizedBox(height: 20),
                          textbutton(() async {
                            await login();
                          }, 'Giriş Yap', mainColor),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'signup');
                            },
                            child: const Text(
                              'Hesabınız yok mu? Kayıt Ol',
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.8,
                child: Image(
                  image: AssetImage("assets/busicon.png"),
                  width: 650,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

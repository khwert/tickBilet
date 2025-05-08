import 'package:company_dashboard/components/ball_contaner.dart';
import 'package:company_dashboard/components/buttons/buttontext.dart';
import 'package:company_dashboard/components/buttons/custombutton.dart';
import 'package:company_dashboard/components/customtextform.dart';
import 'package:company_dashboard/components/func/valid.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController companyname = TextEditingController();

  Crud crud = Crud();
  bool isYukleniyor = false;
  bool success = false;
  signUp() async {
    if (formstate.currentState!.validate()) {
      isYukleniyor = true;
      setState(() {});
      var response = await crud.postRequest(linkSignUp, {
        'company_name': companyname.text,
        'username': username.text,
        'password': password.text,
      });
      isYukleniyor = false;
      setState(() {});
      if (response == null) {
        print("Error: Response is null");
        return;
      }

      if (response.containsKey('status') && response['status'] == 'success') {
        success = true;
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil("login", (route) => false);
      } else {
        print("SignUp Failed: $response");
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
                : success
                    ? Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customButton(() {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "login", (route) => false);
                            },
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: secondaryColor,
                                ),
                                "Kayıt başarılı! Giriş yapınız",
                                secondaryColor,
                                mainColor),
                            Row(
                              children: [
                                ballContainer(Colors.green),
                                ballContainer(Colors.green),
                                ballContainer(Colors.green),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: 500,
                        margin: const EdgeInsets.only(left: 150),
                        child: Form(
                          key: formstate,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Şirket Kaydı',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              CustomTextForm(
                                mycontroller: companyname,
                                hint: 'Şirket Adı',
                                valida: (val) {
                                  return validInput(val!, 5, 100);
                                },
                                icon: const Icon(Icons.business),
                              ),
                              CustomTextForm(
                                mycontroller: username,
                                keyboardType: TextInputType.name,
                                hint: 'Kullanıcı Adı',
                                valida: (val) {
                                  return validInput(val!, 5, 50);
                                },
                                icon: const Icon(Icons.person),
                              ),
                              CustomTextForm(
                                mycontroller: password,
                                keyboardType: TextInputType.visiblePassword,
                                hint: 'Şifre',
                                obscureText: true,
                                valida: (val) {
                                  return validInput(val!, 6, 30);
                                },
                                icon: const Icon(Icons.lock),
                              ),
                              const SizedBox(height: 20),
                              textbutton(() async {
                                await signUp();
                              }, 'Kayıt Ol', mainColor),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Zaten hesabınız var mı? Giriş Yap',
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

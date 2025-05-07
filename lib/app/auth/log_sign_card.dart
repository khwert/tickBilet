import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ticketproject/constant/linkapi.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/components/customtextform.dart';
import 'package:ticketproject/components/my_text_button.dart';
import 'package:ticketproject/components/valid.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/main.dart';

bool isSignupMode = false;
OverlayEntry? overlayEntryLogin;
bool isLoading = false;
void showLoginSignupOverlay(BuildContext context) {
  if (overlayEntryLogin != null) return;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  final Crud crud = Crud();

  GlobalKey<FormState> formstate = GlobalKey();
  signUp() async {
    // Uye Ol
    if (formstate.currentState?.validate() ?? false) {
      isLoading = true;
      var response = await crud.postRequest(linkSignUp, {
        'email': email.text,
        'password_hash': password.text,
        'name': name.text,
      });
      isLoading = false;
      if (response == null) {
        print("Error: Response is null");
        return;
      }
      if (response.containsKey('status') && response['status'] == 'success') {
        sharedPref.setString("email", email.text);
        sharedPref.setString("password_hash", password.text);
        sharedPref.setString("name", name.text);
        overlayEntryLogin?.remove();
        overlayEntryLogin = null;
      } else {
        print("SignUp Failed: $response");
      }
    }
  }

  login() async {
    if (formstate.currentState?.validate() ?? false) {
      isLoading = true;
      var response = await crud.postRequest(linkLogin, {
        'email': email.text,
        'password_hash': password.text,
      });
      isLoading = false;
      if (response == null) {
        print("Error: Response is null");
        return;
      }
      if (response.containsKey('status') && response['status'] == 'success') {
        overlayEntryLogin?.remove();
        overlayEntryLogin = null;
      } else {
        print("SignUp Failed: $response");
      }
    }
  }

  overlayEntryLogin = OverlayEntry(
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () async {
                overlayEntryLogin?.remove();
                overlayEntryLogin = null;
              },
              child: Container(color: Colors.black54),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: generalBackgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                ),
                child: Form(
                  key: formstate, // Assign the GlobalKey to the Form
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidCircleUser,
                        color: secondaryTextColor,
                        size: 25,
                      ),
                      Text(
                        isSignupMode ? "Üye Ol" : "Giriş Yap",
                        textScaler: const TextScaler.linear(1.0),
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      isSignupMode
                          ? CustomTextFormSign(
                              mycontroller: name,
                              hint: "Ad Soyad Giriniz",
                              valida: (val) {
                                return validInput(val!, 10, 100);
                              },
                            )
                          : const Text(''),
                      CustomTextFormSign(
                        mycontroller: email,
                        hint: "E-posta Adresi",
                        valida: (val) {
                          return validInput(val!, 5, 50);
                        },
                      ),
                      CustomTextFormSign(
                        hint: 'Şifre',
                        mycontroller: password,
                        valida: (val) {
                          return validInput(val!, 6, 60);
                        },
                      ),
                      myTextButton(
                        () async {
                          isSignupMode ? await signUp() : await login();
                        },
                        const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 15),
                        isSignupMode ? "Üye Ol" : "Giriş Yap",
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        5,
                      ),
                      isSignupMode
                          ? const SizedBox(height: 8)
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Henüz üye değil misiniz?",
                                textScaler: TextScaler.linear(1.0),
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isSignupMode = !isSignupMode;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: secondaryColor),
                          ),
                        ),
                        child: Text(
                          isSignupMode ? "Giriş Yap" : "Üye Ol",
                          style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntryLogin!);
}

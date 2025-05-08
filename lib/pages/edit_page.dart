import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:company_dashboard/components/buttons/buttontext.dart';
import 'package:company_dashboard/components/customtextform.dart';
import 'package:company_dashboard/components/func/valid.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:company_dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCompanyPage extends StatefulWidget {
  const EditCompanyPage({super.key});

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _logo;
  String? logoName;

  Crud crud = Crud();
  getCopmany() async {
    var response = await crud.postRequest(
        linkCompGit, {"company_id": sharedPref.getString("company_id")});
    return response;
  }

  bool isYukleniyor = false;
  copmanyUpdate() async {
    if (logoName == null) {
      return AwesomeDialog(
          context: context,
          title: "Onemli !!",
          body: const Text("Lutfen Resim Yukleyiniz.."))
        ..show();
    }
    if (_formKey.currentState!.validate()) {
      isYukleniyor = true;
      setState(() {});
      var response;

      if (_logo == null) {
        response = await crud.postRequest(linkUpdate, {
          "company_name": companyNameController.text,
          "descript": descriptionController.text,
          "logoname": logoName,
          "username": usernameController.text,
          "password": passwordController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "company_id": sharedPref.getString("company_id")
        });
      } else {
        response = await crud.postRequestWithFile(
            linkUpdate,
            {
              "company_name": companyNameController.text,
              "descript": descriptionController.text,
              "logoname": logoName,
              "username": usernameController.text,
              "password": passwordController.text,
              "phone": phoneController.text,
              "email": emailController.text,
              "company_id": sharedPref.getString("company_id")
            },
            _logo!);
      }

      if (response['status'] == "success") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("dashboard", (route) => false);
      } else {
        //
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadCompanyData();
  }

  void loadCompanyData() async {
    var response = await getCopmany();
    if (response['status'] == 'success') {
      var data = response['data'];
      setState(() {
        companyNameController.text = data['company_name'] ?? '';
        descriptionController.text = data['descript'] ?? '';
        usernameController.text = data['username'] ?? '';
        passwordController.text = data['password'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        logoName = data['logo'];
      });
    }
  }

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
        logoName ??= pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Düzenle - Şirket Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Şirket Bilgiler:", style: TextStyle(fontSize: 25)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Colors.grey,
                                child: _logo != null
                                    ? Image.file(
                                        _logo!,
                                        height: 80,
                                      )
                                    : (logoName == null || logoName!.isEmpty)
                                        ? Image.asset('assets/busicon.png',
                                            height: 80)
                                        : Image.network(
                                            "$linkLogoRoot/$logoName",
                                            height: 80,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  'assets/busicon.png',
                                                  height: 80);
                                            },
                                          ),
                              ),
                              IconButton(
                                onPressed: pickLogo,
                                icon: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(Icons.add_a_photo_rounded,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextForm(
                            hint: 'Şirket Adı',
                            keyboardType: TextInputType.name,
                            icon: const Icon(Icons.business),
                            mycontroller: companyNameController,
                            valida: (val) {
                              return validInput(val!, 5, 100);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: CustomTextForm(
                        hint: 'Açıklama',
                        keyboardType: TextInputType.multiline,
                        icon: const Icon(Icons.description),
                        mycontroller: descriptionController,
                        valida: (val) {
                          return validInput(val!, 80, 1000);
                        },
                        maxLines: 6,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: mainColor,
                  height: 30,
                ),
                const Text("İletişim Bilgileri:",
                    style: TextStyle(fontSize: 25)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Phone

                    Expanded(
                      child: CustomTextForm(
                        hint: 'Telefon Numarası',
                        keyboardType: TextInputType.phone,
                        icon: const Icon(Icons.phone_enabled_rounded),
                        mycontroller: phoneController,
                        valida: (val) {
                          return validInput(val!, 11, 20);
                        },
                      ),
                    ),

                    const SizedBox(width: 25),
                    // Email

                    Expanded(
                      child: CustomTextForm(
                        hint: 'E-mail',
                        keyboardType: TextInputType.emailAddress,
                        icon: const Icon(Icons.email_rounded),
                        mycontroller: emailController,
                        valida: (val) {
                          return validInput(val!, 6, 100);
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: mainColor,
                  height: 30,
                ),
                const Text("Giriş Çıkış bilgileri:",
                    style: TextStyle(fontSize: 25)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                        hint: 'Kullanıcı Adı',
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.person),
                        mycontroller: usernameController,
                        valida: (val) {
                          return validInput(val!, 5, 50);
                        },
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: CustomTextForm(
                        mycontroller: passwordController,
                        hint: 'Şifre',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        valida: (val) {
                          return validInput(val!, 6, 30);
                        },
                        icon: const Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: textbutton(() {
                    copmanyUpdate();
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

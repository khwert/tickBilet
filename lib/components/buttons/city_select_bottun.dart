import 'package:company_dashboard/constant/city_list_hide.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:company_dashboard/db/crud.dart';
import 'package:company_dashboard/db/linkapi.dart';
import 'package:flutter/material.dart';

class CitySellectButton extends StatefulWidget {
  final String? top;
  final String? middle;
  final Function(int, String)? onCitySelected;

  const CitySellectButton({
    super.key,
    this.top,
    this.middle,
    this.onCitySelected,
  });

  @override
  State<CitySellectButton> createState() => _CitySellectButtonState();
}

class _CitySellectButtonState extends State<CitySellectButton> {
  final LayerLink _layerLink = LayerLink();
  final Crud _crud = Crud();
  late String selectedCity;

  getCities() async {
    var response = await _crud.getRequest(linkCiteisView);
    return response;
  }

  @override
  void initState() {
    super.initState();
    selectedCity = widget.middle ?? "İstanbul";
  }

  void _toggleDropdown(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(overlayEntry!);
    } else {
      hideOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        width: 300,
        child: Material(
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0, renderBox.size.height),
            child: Card(
              elevation: 4,
              color: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 200,
                child: Scrollbar(
                  thickness: 3,
                  child: SingleChildScrollView(
                      child: FutureBuilder(
                          future: getCities(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data['status'] == 'fail') {
                                return const Text(
                                  "Yukleniyor...",
                                  style: TextStyle(color: Colors.white),
                                );
                              }

                              return ListView.builder(
                                itemCount: snapshot.data['data'].length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: Text(
                                      "${snapshot.data['data'][i]['name']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedCity =
                                            snapshot.data['data'][i]['name'];
                                      });
                                      widget.onCitySelected?.call(
                                        snapshot.data['data'][i]['city_id'],
                                        snapshot.data['data'][i]['name'],
                                      );
                                      hideOverlay();
                                    },
                                  );
                                },
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text(
                                  "Yukleniyor ...",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            return const Center(
                              child: Text(
                                "Yukleniyor ...",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          })),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () => _toggleDropdown(context),
        borderRadius: BorderRadius.circular(10),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 50,
              width: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_city_rounded,
                    color: Color.fromARGB(255, 11, 76, 156),
                  ),
                  Text(
                    " ${widget.top!}:  ",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 11, 76, 156),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    selectedCity,
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

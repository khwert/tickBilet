import 'package:flutter/material.dart';
import 'package:ticketproject/app/api/crud.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/constant/city_list.dart';
import 'package:ticketproject/constant/linkapi.dart';

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
              color: Colors.white,
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
                                return const Text("لا يوجد ملاحظات");
                              }

                              return ListView.builder(
                                itemCount: snapshot.data['data'].length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: Text(
                                      "${snapshot.data['data'][i]['name']}",
                                    ),
                                    onTap: () {
                                      setState(() {
                                        // <-- إضافة setState هنا
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
                                child: Text("Loading ..."),
                              );
                            }
                            return const Center(
                              child: Text("Loading ..."),
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
          color: generalBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: SizedBox(
              height: 75,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.top!,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Text("${widget.fff}"),
                  Text(
                    selectedCity,
                    style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

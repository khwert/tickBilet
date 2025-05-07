import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketproject/app/auth/log_sign_card.dart';
import 'package:ticketproject/constant/colors.dart';
import 'package:ticketproject/main.dart';

class CustomAppBarForWeb extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarForWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Text(
        'tickBilet',
        style: GoogleFonts.emblemaOne(
          color: generalBackgroundColor,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text("Üye Girişi",
              style: TextStyle(
                color: generalBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

///
///
class CustomAppBar extends StatefulWidget {
  final String homeControl;

  const CustomAppBar({
    super.key,
    required this.homeControl,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'tickBilet',
              style: GoogleFonts.emblemaOne(
                color: generalBackgroundColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.homeControl == "home"
                ? const Text('')
                : IconButton(
                    padding: const EdgeInsets.only(left: 30),
                    icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                        color: generalBackgroundColor),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
            Expanded(child: MoveWindow()),
            Text(
              sharedPref.getString("name") ?? "Giriş",
              style:
                  const TextStyle(color: generalBackgroundColor, fontSize: 18),
            ),
            IconButton(
                padding: const EdgeInsets.only(right: 20, left: 20),
                onPressed: () {
                  showLoginSignupOverlay(context);
                },
                icon: Icon(
                  FontAwesomeIcons.solidCircleUser,
                  color: sharedPref.getString("email") == null
                      ? generalBackgroundColor
                      : Colors.green,
                  size: 22,
                )),
            const WindowButtons(),
          ],
        ),
      ),
    );
  }
}

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFC0392B),
  mouseDown: const Color(0xFF922B21),
  iconNormal: Colors.white,
);

final minimizeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD4AC0D),
  mouseDown: const Color(0xFFB7950B),
  iconNormal: Colors.white,
);

final maximizeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFF28B463),
  mouseDown: const Color(0xFF1D8348),
  iconNormal: Colors.white,
);

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: minimizeButtonColors,
        ),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: maximizeButtonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: maximizeButtonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

import 'package:flutter/material.dart';

OverlayEntry? overlayEntry;

void hideOverlay() {
  overlayEntry?.remove();
  overlayEntry = null;
}

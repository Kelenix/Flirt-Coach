import 'package:flutter/material.dart';

extension ShowMessage on ScaffoldMessengerState {
  /// Affiche [message] en bas d'écran, à la place du message précédent.
  void showMessage(String message) => this
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

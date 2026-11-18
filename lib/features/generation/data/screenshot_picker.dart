import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/failure.dart';

/// Ouvre le sélecteur de photos du système ; `null` si l'utilisateur annule.
typedef ScreenshotPicker = Future<Uint8List?> Function();

/// Limite côté serveur (Edge Function `screenshot-reply`).
const maxScreenshotBytes = 3500000;

final screenshotPickerProvider = Provider<ScreenshotPicker>(
  (ref) => () async {
    // Sélecteur système : aucune permission permanente sur la galerie.
    // L'image est réduite pour rester légère sans perdre la lisibilité du texte.
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 2800,
      imageQuality: 85,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    if (bytes.length > maxScreenshotBytes) throw const ImageTooLargeFailure();
    return bytes;
  },
);

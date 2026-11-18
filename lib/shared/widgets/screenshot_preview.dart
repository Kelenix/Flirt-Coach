import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Aperçu de la capture choisie, avec une information (coût, non-conservation).
class ScreenshotPreview extends StatelessWidget {
  const ScreenshotPreview({
    super.key,
    required this.bytes,
    required this.onRemove,
    required this.info,
  });

  static const _thumbnailWidth = 90.0;
  static const _thumbnailHeight = 160.0;

  final Uint8List bytes;
  final VoidCallback onRemove;
  final String info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    // Taille fixe : une image large ou panoramique ne déborde pas.
                    child: Image.memory(
                      bytes,
                      width: _thumbnailWidth,
                      height: _thumbnailHeight,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      semanticLabel: l10n.screenshotSelected,
                      // Image illisible : même taille que la vignette.
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            width: _thumbnailWidth,
                            height: _thumbnailHeight,
                            child: Icon(
                              AppIcons.screenshot,
                              color: AppColors.onLight,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l10n.screenshotSelected,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.onLight,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(AppIcons.close),
                    color: AppColors.onLight,
                    tooltip: l10n.removeScreenshot,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                info,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.onLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/theme.dart';
import '../core/models/avatar_model.dart';

class AvatarDisplayWidget extends StatelessWidget {
  final Avatar avatar;
  final bool isPlaying;
  final VoidCallback? onTap;
  final String? narrationText;

  const AvatarDisplayWidget({
    required this.avatar,
    this.isPlaying = false,
    this.onTap,
    this.narrationText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: isPlaying ? AppColors.gradientPrimary : null,
          color: isPlaying ? null : AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Avatar Circle with Pulse Animation
            Stack(
              alignment: Alignment.center,
              children: [
                // Pulse background (when playing)
                if (isPlaying)
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),

                // Avatar Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgTertiary,
                    border: Border.all(
                      color: isPlaying ? Colors.white : AppColors.primary,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: isPlaying ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),

                // Playing indicator
                if (isPlaying)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Avatar Name
            Text(
              avatar.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.white : AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // Personality
            Text(
              avatar.personality,
              style: TextStyle(
                fontSize: 14,
                color: isPlaying
                    ? Colors.white.withOpacity(0.9)
                    : AppColors.textTertiary,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Description Quote
            if (narrationText != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isPlaying ? Colors.white.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Text(
                  '"$narrationText"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPlaying
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            if (narrationText == null) const SizedBox(height: AppSpacing.md),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isPlaying
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPlaying
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPlaying ? Icons.volume_up : Icons.volume_off,
                    size: 14,
                    color: isPlaying ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isPlaying ? 'Now Narrating' : 'Ready to Narrate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? Colors.white : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/theme.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final double speechRate;
  final ValueChanged<double> onSpeedChanged;
  final double pitch;
  final ValueChanged<double> onPitchChanged;

  const AudioControls({
    required this.isPlaying,
    required this.onPlayPause,
    this.onPrevious,
    this.onNext,
    required this.speechRate,
    required this.onSpeedChanged,
    required this.pitch,
    required this.onPitchChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.bgTertiary)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speed Control
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  'Speed',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Slider(
                  value: speechRate,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: AppColors.accent,
                  inactiveColor: AppColors.bgTertiary,
                  onChanged: onSpeedChanged,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${(speechRate * 2).toStringAsFixed(1)}x',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Pitch Control
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  'Pitch',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Slider(
                  value: pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 10,
                  activeColor: AppColors.secondary,
                  inactiveColor: AppColors.bgTertiary,
                  onChanged: onPitchChanged,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  pitch.toStringAsFixed(1),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Play/Pause Button
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPlayPause,
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        isPlaying ? 'Pause' : 'Play Narration',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }
}

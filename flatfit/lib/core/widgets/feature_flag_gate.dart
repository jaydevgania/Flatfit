import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/core/di/service_locator.dart';

/// Widget that only renders its [child] if the specified [flagKey] is enabled.
class FeatureFlagGate extends ConsumerWidget {
  final String flagKey;
  final Widget child;
  final Widget fallback;

  const FeatureFlagGate({
    super.key,
    required this.flagKey,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flagService = ref.watch(featureFlagServiceProvider);
    final isEnabled = flagService.isEnabled(flagKey);

    return isEnabled ? child : fallback;
  }
}

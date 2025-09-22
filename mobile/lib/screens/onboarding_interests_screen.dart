import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class OnboardingInterestsScreen extends ConsumerStatefulWidget {
  const OnboardingInterestsScreen({Key? key}) : super(key: key);

  static const routeName = '/onboarding/interests';

  @override
  ConsumerState<OnboardingInterestsScreen> createState() => _OnboardingInterestsScreenState();
}

class _OnboardingInterestsScreenState extends ConsumerState<OnboardingInterestsScreen> {
  final List<String> _all = [
    'music', 'sports', 'outdoor', 'travel', 'tech', 'food', 'family', 'arts', 'running', 'hiking'
  ];
  final Set<String> _selected = {};
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose interests')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pick a few topics you like. We will personalize your feed.'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _all.map((t) {
                final sel = _selected.contains(t);
                return FilterChip(
                  label: Text(t),
                  selected: sel,
                  onSelected: (v) => setState(() => v ? _selected.add(t) : _selected.remove(t)),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving || user == null ? null : () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  setState(() => _saving = true);
                  try {
                    final firestore = ref.read(firestoreServiceProvider);
                    await firestore.saveUserInterests(user.uid, _selected.toList());
                    if (mounted) navigator.pop(true);
                  } catch (e) {
                    messenger.showSnackBar(SnackBar(content: Text('Failed to save: $e')));
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
                child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save interests'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

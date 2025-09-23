import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends ConsumerState<AccountScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  Future<void> _linkGoogle() async {
    setState(() => _loading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.linkWithGoogle();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Linked with Google')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _linkEmail() async {
    setState(() => _loading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.linkWithEmail(_emailCtl.text.trim(), _passCtl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Linked with email')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    setState(() => _loading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.sendPasswordReset(_emailCtl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset sent')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (user != null) ...[
              Text('Signed in as: ${user.email ?? user.displayName ?? user.uid}'),
              const SizedBox(height: 12),
            ],
            TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password (for linking)')), 
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _linkGoogle, child: const Text('Link with Google')),
            ElevatedButton(onPressed: _loading ? null : _linkEmail, child: const Text('Link with Email/Password')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _resetPassword, child: const Text('Send password reset')),
          ],
        ),
      ),
    );
  }
}

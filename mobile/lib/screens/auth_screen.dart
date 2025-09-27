import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInEmail() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.signInWithEmail(_emailCtl.text.trim(), _passCtl.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpEmail() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.signUpWithEmail(_emailCtl.text.trim(), _passCtl.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-up failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInGoogle() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final svc = ref.read(authServiceProvider);
      await svc.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: authState.when(
        data: (user) {
          if (user != null) {
            return const Center(child: Text('Signed in — returning to app...'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 8),
                TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _isLoading ? null : _signInEmail, child: Text(_isLoading ? 'Signing in...' : 'Sign in')),
                TextButton(onPressed: _isLoading ? null : _signUpEmail, child: const Text('Create account')),
                const Divider(),
                ElevatedButton.icon(onPressed: _isLoading ? null : _signInGoogle, icon: const Icon(Icons.login), label: const Text('Continue with Google')),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Auth error: $e')),
      ),
    );
  }
}

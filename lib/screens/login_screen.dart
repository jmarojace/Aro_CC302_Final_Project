import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../state/auth_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;
  String? _error;
  late final VideoPlayerController _backgroundVideo;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _backgroundVideo = VideoPlayerController.asset(
      'assets/videos/login_background.mp4',
    );
    _startBackgroundVideo();
  }

  Future<void> _startBackgroundVideo() async {
    try {
      await _backgroundVideo.initialize();
      await _backgroundVideo.setLooping(true);
      await _backgroundVideo.setVolume(0);
      await _backgroundVideo.play();
      if (mounted) setState(() => _videoReady = true);
    } catch (_) {
      // Keep the still store photo visible if video playback isn't supported.
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _backgroundVideo.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final ok = auth.login(_email.text, _password.text);
    setState(() => _error = ok ? null : 'Wrong email or password. Please try again.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_videoReady)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _backgroundVideo.value.size.width,
                  height: _backgroundVideo.value.size.height,
                  child: VideoPlayer(_backgroundVideo),
                ),
              ),
            )
          else
            Image.asset(
              'assets/images/store_background.webp',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x660A2730), Color(0xCC071D23)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 24, offset: Offset(0, 8))],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 58,
                          errorBuilder: (_, __, ___) => const Icon(Icons.storefront, size: 58, color: Color(0xFF0F4C5C)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Mini Store',
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: .3),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Your neighborhood store, made simple.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFE2EEF0), fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white.withValues(alpha: .97),
                        elevation: 18,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text('Welcome back', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF16282D))),
                                const SizedBox(height: 5),
                                Text('Sign in to manage your inventory', style: TextStyle(color: Colors.blueGrey.shade600)),
                                const SizedBox(height: 22),
                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: const Icon(Icons.mail_outline),
                                    filled: true,
                                    fillColor: const Color(0xFFF5F8F8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                  ),
                                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null,
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _password,
                                  obscureText: _hide,
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    filled: true,
                                    fillColor: const Color(0xFFF5F8F8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                    suffixIcon: IconButton(
                                      tooltip: _hide ? 'Show password' : 'Hide password',
                                      icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                      onPressed: () => setState(() => _hide = !_hide),
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                                ),
                                if (_error != null) ...[
                                  const SizedBox(height: 12),
                                  Text(_error!, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
                                ],
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.login),
                                  label: const Text('Sign in'),
                                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: const Color(0xFF0F4C5C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('TRACK STOCK  ·  SERVE YOUR COMMUNITY', style: TextStyle(color: Color(0xFFD6E4E7), fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
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

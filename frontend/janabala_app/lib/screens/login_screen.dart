import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../services/api_client.dart";
import "../services/auth_service.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtl = TextEditingController();
  final _otpCtl = TextEditingController();

  bool _otpStep = false;
  bool _busy = false;
  String? _error;
  String? _devOtp;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneCtl.dispose();
    _otpCtl.dispose();
    super.dispose();
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    setState(() => _cooldown = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldown <= 1) {
        t.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  Future<void> _sendOtp() async {
    final auth = context.read<AuthService>();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final devOtp = await auth.sendOtp(_phoneCtl.text.trim());
      setState(() {
        _otpStep = true;
        _devOtp = kDebugMode ? devOtp : null;
        if (kDebugMode && devOtp != null) _otpCtl.text = devOtp;
      });
      _startCooldown(60); // backend enforces a 60s resend cooldown
    } on ApiException catch (e) {
      if (e.isRateLimited) {
        _startCooldown(e.retryAfterSeconds ?? 60);
        setState(() => _error = e.message);
      } else {
        setState(() => _error = e.message);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final auth = context.read<AuthService>();
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await auth.verifyAndLogin(_phoneCtl.text.trim(), _otpCtl.text.trim());
      // _Root rebuilds into HomeScreen on auth change.
    } on ApiException catch (e) {
      setState(() => _error = e.isRateLimited ? l10n.tooManyAttempts : e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.login,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],
                if (!_otpStep) ...[
                  TextField(
                    controller: _phoneCtl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _sendOtp,
                    child: Text(_busy ? l10n.sending : l10n.sendOtp),
                  ),
                ] else ...[
                  if (_devOtp != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("${l10n.devOtp}: $_devOtp"),
                    ),
                  TextField(
                    controller: _otpCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.enterOtp,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _verify,
                    child: Text(_busy ? l10n.verifying : l10n.verifyLogin),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: (_busy || _cooldown > 0) ? null : _sendOtp,
                    child: Text(_cooldown > 0
                        ? l10n.resendIn(_cooldown)
                        : l10n.sendOtp),
                  ),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _otpStep = false;
                              _otpCtl.clear();
                              _devOtp = null;
                            }),
                    child: Text(l10n.changeNumber),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

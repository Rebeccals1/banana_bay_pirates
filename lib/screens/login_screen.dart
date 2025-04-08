// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth/auth_service.dart';
import '../widgets/auth_card.dart';
import '../widgets/login/animated_logo_header.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLogin = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        if (_isLogin) {
          await _authService.signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await _authService.createUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() => _errorMessage = e.message ?? 'An error occurred');
      } catch (e) {
        setState(() => _errorMessage = e.toString());
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    await _handleAuth(() async => await _authService.signInWithGoogle());
  }

  Future<void> _signInAnonymously() async {
    await _handleAuth(() async => await _authService.signInAnonymously());
  }

  Future<void> _handleAuth(Future<void> Function() authMethod) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await authMethod();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal, Colors.green],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 900 : 600,
                    ),
                    child: isLandscape
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: AnimatedLogoHeader()),
                        const SizedBox(width: 32),
                        Expanded(
                          child: SingleChildScrollView(
                            child: AuthCard(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isLogin: _isLogin,
                              isLoading: _isLoading,
                              errorMessage: _errorMessage,
                              onSubmit: _submitForm,
                              onToggleMode: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _errorMessage = '';
                                });
                              },
                              onGoogleSignIn: _signInWithGoogle,
                              onGuestSignIn: _signInAnonymously,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedLogoHeader(),
                        const SizedBox(height: 32),
                        AuthCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isLogin: _isLogin,
                          isLoading: _isLoading,
                          errorMessage: _errorMessage,
                          onSubmit: _submitForm,
                          onToggleMode: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _errorMessage = '';
                            });
                          },
                          onGoogleSignIn: _signInWithGoogle,
                          onGuestSignIn: _signInAnonymously,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

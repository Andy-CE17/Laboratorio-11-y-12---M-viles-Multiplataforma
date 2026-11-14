import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'admin@demo.com');
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_email.text.trim() != AppState.instance.email ||
        _password.text != '123456') {
      showMessage(
        context,
        'No se pudo ingresar',
        'Correo o contraseña incorrectos.',
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = CupertinoTheme.of(context).primaryColor;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(CupertinoIcons.cube_box_fill, size: 78, color: accent),
                  const SizedBox(height: 20),
                  const Text(
                    'Sistema de Productos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Laboratorio 11 · Estilo Cupertino',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CupertinoColors.secondaryLabel),
                  ),
                  const SizedBox(height: 32),
                  CupertinoTextField(
                    controller: _email,
                    placeholder: 'Correo electrónico',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(CupertinoIcons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    padding: const EdgeInsets.all(15),
                    clearButtonMode: OverlayVisibilityMode.editing,
                  ),
                  const SizedBox(height: 14),
                  CupertinoTextField(
                    controller: _password,
                    placeholder: 'Contraseña',
                    obscureText: _obscure,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(CupertinoIcons.lock),
                    ),
                    suffix: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    onSubmitted: (_) => _signIn(),
                  ),
                  const SizedBox(height: 22),
                  CupertinoButton.filled(
                    onPressed: _signIn,
                    child: const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Prueba: admin@demo.com · contraseña: 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

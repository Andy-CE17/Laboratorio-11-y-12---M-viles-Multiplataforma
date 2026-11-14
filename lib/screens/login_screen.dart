import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/app_ui.dart';
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
    final accent = appAccent(context);
    return CupertinoPageScaffold(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 820;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 32 : 20,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14203962),
                          blurRadius: 45,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: wide
                        ? Row(
                            children: [
                              Expanded(child: _brandPanel(accent, tall: true)),
                              Expanded(child: _loginForm(accent)),
                            ],
                          )
                        : Column(
                            children: [
                              _brandPanel(accent, tall: false),
                              _loginForm(accent),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _brandPanel(Color accent, {required bool tall}) => Container(
    constraints: BoxConstraints(minHeight: tall ? 540 : 190),
    padding: EdgeInsets.all(tall ? 48 : 28),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, Color.lerp(accent, appInk, 0.48)!],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0x32FFFFFF),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            CupertinoIcons.cube_box_fill,
            color: CupertinoColors.white,
            size: 28,
          ),
        ),
        SizedBox(height: tall ? 35 : 18),
        const Text(
          'Sistema de Productos',
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: 31,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Organiza tu catálogo con una experiencia clara y sencilla.',
          style: TextStyle(color: Color(0xDFFFFFFF), fontSize: 15, height: 1.5),
        ),
        if (tall) ...[
          const SizedBox(height: 48),
          const Text(
            'LABORATORIO 11  ·  FLUTTER CUPERTINO',
            style: TextStyle(
              color: Color(0xBFFFFFFF),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ],
    ),
  );

  Widget _loginForm(Color accent) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 42),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bienvenido de nuevo',
          style: TextStyle(
            color: appInk,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Ingresa tus datos para continuar.',
          style: TextStyle(color: appMuted, fontSize: 14),
        ),
        const SizedBox(height: 32),
        appField(
          label: 'Correo electrónico',
          controller: _email,
          placeholder: 'Correo electrónico',
          keyboardType: TextInputType.emailAddress,
          prefix: const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(CupertinoIcons.mail, color: appMuted, size: 19),
          ),
        ),
        const SizedBox(height: 20),
        appField(
          label: 'Contraseña',
          controller: _password,
          placeholder: 'Contraseña',
          obscureText: _obscure,
          onSubmitted: (_) => _signIn(),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(CupertinoIcons.lock, color: appMuted, size: 19),
          ),
          suffix: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              size: 19,
              color: appMuted,
            ),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          height: 50,
          child: CupertinoButton.filled(
            onPressed: _signIn,
            borderRadius: BorderRadius.circular(13),
            child: const Text('Iniciar sesión'),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Text(
            'Acceso de prueba: admin@demo.com  ·  123456',
            textAlign: TextAlign.center,
            style: TextStyle(color: appMuted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

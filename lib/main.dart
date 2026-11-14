import 'package:flutter/cupertino.dart';

import 'app_state.dart';
import 'screens/login_screen.dart';
import 'widgets/app_ui.dart';

void main() => runApp(const ProductApp());

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema de Productos Cupertino',
        theme: CupertinoThemeData(
          primaryColor: AppState.instance.accent,
          brightness: Brightness.light,
          scaffoldBackgroundColor: appBackground,
          barBackgroundColor: CupertinoColors.white,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

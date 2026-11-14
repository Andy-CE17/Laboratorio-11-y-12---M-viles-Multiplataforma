import 'package:flutter/cupertino.dart';

import 'app_state.dart';
import 'screens/login_screen.dart';

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
          scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

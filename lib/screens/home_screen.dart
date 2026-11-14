import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';
import 'product_form_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            label: 'Perfil',
          ),
        ],
      ),
      tabBuilder: (context, index) => CupertinoTabView(
        builder: (context) => switch (index) {
          0 => const DashboardPage(),
          1 => const ProductsPage(),
          2 => const ProductFormPage(),
          _ => const ProfilePage(),
        },
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Inicio')),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) => ListView(
            children: [
              pageTitle(
                'Hola, ${AppState.instance.name.split(' ').first}',
                subtitle: 'Bienvenido al sistema de productos',
              ),
              CupertinoListSection.insetGrouped(
                header: const Text('RESUMEN'),
                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.cube_box),
                    title: const Text('Productos registrados'),
                    trailing: Text('${AppState.instance.products.length}'),
                  ),
                  const CupertinoListTile(
                    leading: Icon(CupertinoIcons.device_phone_portrait),
                    title: Text('Interfaz'),
                    trailing: Text('Cupertino'),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text(
                  'Usa las pestañas inferiores para buscar, registrar y administrar productos o editar tu perfil.',
                  style: TextStyle(color: CupertinoColors.secondaryLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/app_ui.dart';
import 'product_form_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: appAccent(context),
        backgroundColor: CupertinoColors.white,
        border: const Border(top: BorderSide(color: appBorder)),
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
    final accent = appAccent(context);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Panel principal'),
      ),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final products = AppState.instance.products;
            final total = products.fold<double>(0, (sum, p) => sum + p.price);
            final categories = products.map((p) => p.category).toSet().length;
            return appContent(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 36),
                children: [
                  sectionHeading(
                    'Panel general',
                    'Hola, ${AppState.instance.name.split(' ').first}',
                    subtitle: 'Bienvenido a tu espacio de trabajo.',
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, Color.lerp(accent, appInk, 0.52)!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TU CATÁLOGO, EN ORDEN',
                          style: TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Gestiona tus productos\nen un solo lugar.',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Busca, registra y organiza tu inventario desde las pestañas inferiores.',
                          style: TextStyle(
                            color: Color(0xE5FFFFFF),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  const Text(
                    'Resumen',
                    style: TextStyle(
                      color: appInk,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 650;
                      final items = [
                        _metric(
                          'Productos registrados',
                          '${products.length}',
                          CupertinoIcons.cube_box,
                          accent,
                        ),
                        _metric(
                          'Categorías',
                          '$categories',
                          CupertinoIcons.square_grid_2x2,
                          const Color(0xFF8B63D9),
                        ),
                        _metric(
                          'Valor del catálogo',
                          'S/ ${total.toStringAsFixed(0)}',
                          CupertinoIcons.money_dollar_circle,
                          const Color(0xFF1EAD89),
                        ),
                      ];
                      return wide
                          ? Row(
                              children: [
                                for (var i = 0; i < items.length; i++) ...[
                                  if (i > 0) const SizedBox(width: 14),
                                  Expanded(child: items[i]),
                                ],
                              ],
                            )
                          : Column(
                              children: [
                                for (final item in items) ...[
                                  item,
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, Color color) =>
      appCard(
        child: Row(
          children: [
            iconBadge(icon, color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: appMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: appInk,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

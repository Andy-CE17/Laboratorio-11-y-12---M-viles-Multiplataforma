import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';
import '../widgets/app_ui.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _query = '';
  String _category = 'Todos';

  Future<void> _showProduct(Product product) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(product.name),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child: product.imageBytes == null
                    ? Icon(product.icon, size: 66)
                    : Image.memory(product.imageBytes!, fit: BoxFit.contain),
              ),
              Text('Categoría: ${product.category}'),
              Text('Precio: S/ ${product.price.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text(product.description),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _confirmDelete(product);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Deseas eliminar «${product.name}»?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      AppState.instance.removeProduct(product);
      if (mounted) showMessage(context, 'Producto eliminado', product.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = appAccent(context);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Productos')),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final all = AppState.instance.products;
            final shown = all.where((product) {
              final text = '${product.name} ${product.category}'.toLowerCase();
              return text.contains(_query.toLowerCase().trim()) &&
                  (_category == 'Todos' || product.category == _category);
            }).toList();
            return appContent(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 36),
                children: [
                  sectionHeading(
                    'Catálogo',
                    'Productos',
                    subtitle:
                        '${shown.length} de ${all.length} productos disponibles',
                  ),
                  const SizedBox(height: 24),
                  appCard(
                    padding: const EdgeInsets.all(16),
                    child: CupertinoSearchTextField(
                      placeholder: 'Buscar por nombre o categoría',
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final category in [
                          'Todos',
                          'Tecnología',
                          'Muebles',
                          'Otros',
                        ]) ...[
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            color: _category == category
                                ? accent
                                : CupertinoColors.white,
                            onPressed: () =>
                                setState(() => _category = category),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: _category == category
                                    ? CupertinoColors.white
                                    : appInk,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  if (shown.isEmpty)
                    appCard(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              color: appMuted,
                              size: 33,
                            ),
                            SizedBox(height: 13),
                            Text(
                              'No se encontraron productos',
                              style: TextStyle(
                                color: appInk,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Prueba con otra búsqueda o categoría.',
                              style: TextStyle(color: appMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 760 ? 2 : 1;
                        final gap = 15.0;
                        final width =
                            (constraints.maxWidth - gap * (columns - 1)) /
                            columns;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final product in shown)
                              SizedBox(
                                width: width,
                                child: _productCard(product, accent),
                              ),
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

  Widget _productCard(Product product, Color accent) => GestureDetector(
    onTap: () => _showProduct(product),
    child: appCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          productArtwork(product, accent, size: 62),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: appInk,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.category,
                  style: const TextStyle(color: appMuted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'S/ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.chevron_forward, size: 16, color: appMuted),
        ],
      ),
    ),
  );
}

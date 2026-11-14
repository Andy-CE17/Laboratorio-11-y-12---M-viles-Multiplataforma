import 'package:flutter/cupertino.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _query = '';

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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Productos')),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final all = AppState.instance.products;
            final shown = all.where((product) {
              final text = '${product.name} ${product.category}'.toLowerCase();
              return text.contains(_query.toLowerCase().trim());
            }).toList();
            return ListView(
              children: [
                pageTitle(
                  'Productos',
                  subtitle: '${shown.length} de ${all.length} productos',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoSearchTextField(
                    placeholder: 'Buscar por nombre o categoría',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(height: 10),
                if (shown.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(28),
                    child: Center(child: Text('No se encontraron productos.')),
                  )
                else
                  CupertinoListSection.insetGrouped(
                    children: [
                      for (final product in shown)
                        CupertinoListTile(
                          leading: product.imageBytes == null
                              ? Icon(product.icon, size: 28)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    product.imageBytes!,
                                    width: 34,
                                    height: 34,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(product.name),
                          subtitle: Text(product.category),
                          additionalInfo: Text(
                            'S/ ${product.price.toStringAsFixed(2)}',
                          ),
                          trailing: const Icon(
                            CupertinoIcons.chevron_forward,
                            size: 16,
                          ),
                          onTap: () => _showProduct(product),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

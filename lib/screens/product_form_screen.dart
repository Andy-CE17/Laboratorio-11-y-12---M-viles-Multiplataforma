import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  String _category = 'Tecnología';
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (mounted) setState(() => _imageBytes = bytes);
    } catch (_) {
      if (mounted) {
        showMessage(
          context,
          'Imagen no disponible',
          'No se pudo seleccionar la imagen. Puedes guardar el producto sin ella.',
        );
      }
    }
  }

  Future<void> _chooseCategory() async {
    final category = await showCupertinoModalPopup<String>(
      context: context,
      builder: (popupContext) => CupertinoActionSheet(
        title: const Text('Categoría'),
        actions: [
          for (final value in ['Tecnología', 'Muebles', 'Otros'])
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(popupContext).pop(value),
              child: Text(value),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(popupContext).pop(),
          child: const Text('Cancelar'),
        ),
      ),
    );
    if (category != null) setState(() => _category = category);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final price = double.tryParse(_price.text.trim().replaceAll(',', '.'));
    final description = _description.text.trim();
    if (name.isEmpty || price == null || price <= 0 || description.isEmpty) {
      await showMessage(
        context,
        'Datos incompletos',
        'Ingresa nombre, precio mayor que cero y descripción.',
      );
      return;
    }

    AppState.instance.addProduct(
      Product(
        name: name,
        price: price,
        category: _category,
        description: description,
        icon: CupertinoIcons.cube_box,
        imageBytes: _imageBytes,
      ),
    );
    _name.clear();
    _price.clear();
    _description.clear();
    setState(() {
      _category = 'Tecnología';
      _imageBytes = null;
    });
    if (mounted) {
      await showMessage(
        context,
        'Producto registrado',
        'Abre la pestaña Productos para verlo en la lista.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Registrar')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          children: [
            pageTitle(
              'Nuevo producto',
              subtitle: 'Completa los datos del registro',
            ),
            const SizedBox(height: 8),
            const Text('Nombre', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _name,
              placeholder: 'Nombre del producto',
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 18),
            const Text(
              'Precio (S/)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _price,
              placeholder: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 18),
            const Text(
              'Categoría',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: CupertinoColors.secondarySystemGroupedBackground,
              onPressed: _chooseCategory,
              child: Row(
                children: [
                  Text(
                    _category,
                    style: const TextStyle(color: CupertinoColors.label),
                  ),
                  const Spacer(),
                  const Icon(CupertinoIcons.chevron_down, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _description,
              placeholder: 'Describe el producto',
              maxLines: 3,
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: _pickImage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.photo_on_rectangle),
                  const SizedBox(width: 8),
                  Text(
                    _imageBytes == null
                        ? 'Seleccionar imagen (opcional)'
                        : 'Cambiar imagen',
                  ),
                ],
              ),
            ),
            if (_imageBytes != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 18),
            CupertinoButton.filled(
              onPressed: _save,
              child: const Text('Guardar producto'),
            ),
          ],
        ),
      ),
    );
  }
}

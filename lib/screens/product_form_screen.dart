import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';
import '../widgets/app_ui.dart';

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
    final accent = appAccent(context);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nuevo producto'),
      ),
      child: SafeArea(
        child: appContent(
          maxWidth: 760,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 38),
            children: [
              sectionHeading(
                'Registro',
                'Nuevo producto',
                subtitle: 'Completa la información para añadirlo al catálogo.',
              ),
              const SizedBox(height: 24),
              appCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        iconBadge(CupertinoIcons.cube_box, accent),
                        const SizedBox(width: 13),
                        const Text(
                          'Información del producto',
                          style: TextStyle(
                            color: appInk,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    appField(
                      label: 'Nombre',
                      controller: _name,
                      placeholder: 'Nombre del producto',
                    ),
                    const SizedBox(height: 19),
                    appField(
                      label: 'Precio (S/)',
                      controller: _price,
                      placeholder: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 19),
                    const Text(
                      'Categoría',
                      style: TextStyle(
                        color: appInk,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      color: const Color(0xFFFAFBFD),
                      borderRadius: BorderRadius.circular(13),
                      onPressed: _chooseCategory,
                      child: Row(
                        children: [
                          Text(
                            _category,
                            style: const TextStyle(color: appInk, fontSize: 15),
                          ),
                          const Spacer(),
                          const Icon(
                            CupertinoIcons.chevron_down,
                            size: 17,
                            color: appMuted,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19),
                    appField(
                      label: 'Descripción',
                      controller: _description,
                      placeholder: 'Describe el producto',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 23),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(21),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (_imageBytes == null)
                              iconBadge(
                                CupertinoIcons.photo_on_rectangle,
                                accent,
                                size: 48,
                              )
                            else
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _imageBytes!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 11),
                            Text(
                              _imageBytes == null
                                  ? 'Seleccionar imagen'
                                  : 'Cambiar imagen',
                              style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Opcional · JPG o PNG',
                              style: TextStyle(color: appMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      child: CupertinoButton.filled(
                        onPressed: _save,
                        borderRadius: BorderRadius.circular(13),
                        child: const Text('Guardar producto'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

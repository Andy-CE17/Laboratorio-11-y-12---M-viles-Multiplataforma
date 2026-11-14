import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../widgets/dialogs.dart';
import '../widgets/app_ui.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _pickAvatar(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final Uint8List bytes = await image.readAsBytes();
      AppState.instance.updateAvatar(bytes);
    } catch (_) {
      if (context.mounted) {
        showMessage(
          context,
          'Imagen no disponible',
          'No se pudo seleccionar la foto de perfil.',
        );
      }
    }
  }

  Future<void> _editProfile(BuildContext context) async {
    final name = TextEditingController(text: AppState.instance.name);
    final email = TextEditingController(text: AppState.instance.email);
    final save = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Editar perfil'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(controller: name, placeholder: 'Nombre'),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: email,
                placeholder: 'Correo electrónico',
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (save == true && context.mounted) {
      final newName = name.text.trim();
      final newEmail = email.text.trim();
      if (newName.isEmpty || !newEmail.contains('@')) {
        await showMessage(
          context,
          'Datos inválidos',
          'Ingresa un nombre y un correo electrónico válido.',
        );
      } else {
        AppState.instance.updateProfile(newName, newEmail);
      }
    }
    name.dispose();
    email.dispose();
  }

  Future<void> _chooseTheme(BuildContext context) async {
    final color = await showCupertinoModalPopup<Color>(
      context: context,
      builder: (popupContext) => CupertinoActionSheet(
        title: const Text('Color de la aplicación'),
        actions: [
          for (final (label, value) in [
            ('Azul', CupertinoColors.activeBlue),
            ('Verde', CupertinoColors.activeGreen),
            ('Naranja', CupertinoColors.activeOrange),
            ('Morado', CupertinoColors.systemPurple),
          ])
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(popupContext).pop(value),
              child: Text(label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(popupContext).pop(),
          child: const Text('Cancelar'),
        ),
      ),
    );
    if (color != null) AppState.instance.updateAccent(color);
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas volver al inicio de sesión?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Perfil')),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final state = AppState.instance;
            return appContent(
              maxWidth: 760,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 36),
                children: [
                  sectionHeading(
                    'Cuenta',
                    'Perfil y configuración',
                    subtitle: 'Personaliza tu espacio de trabajo.',
                  ),
                  const SizedBox(height: 23),
                  appCard(
                    child: Column(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _pickAvatar(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: appAccent(context),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: state.avatarBytes == null
                                  ? Image.asset(
                                      'assets/images/profile_avatar.png',
                                      width: 94,
                                      height: 94,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      state.avatarBytes!,
                                      width: 94,
                                      height: 94,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        Text(
                          state.name,
                          style: const TextStyle(
                            color: appInk,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          state.email,
                          style: const TextStyle(color: appMuted, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Toca la foto para cambiarla',
                          style: TextStyle(
                            color: appAccent(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Preferencias',
                    style: TextStyle(
                      color: appInk,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoListSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.pencil),
                        title: const Text('Editar perfil'),
                        trailing: const Icon(
                          CupertinoIcons.chevron_forward,
                          size: 16,
                        ),
                        onTap: () => _editProfile(context),
                      ),
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.bell),
                        title: const Text('Notificaciones'),
                        trailing: CupertinoSwitch(
                          value: state.notificationsEnabled,
                          onChanged: state.updateNotifications,
                        ),
                      ),
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.paintbrush),
                        title: const Text('Tema de color'),
                        additionalInfo: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: state.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.chevron_forward,
                          size: 16,
                        ),
                        onTap: () => _chooseTheme(context),
                      ),
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.info),
                        title: const Text('Acerca de'),
                        trailing: const Icon(
                          CupertinoIcons.chevron_forward,
                          size: 16,
                        ),
                        onTap: () => showMessage(
                          context,
                          'Sistema de Productos',
                          'Laboratorio 11. Versión Cupertino del laboratorio de la semana 8.',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CupertinoButton(
                      onPressed: () => _logout(context),
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

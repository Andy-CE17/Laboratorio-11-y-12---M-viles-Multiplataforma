# Laboratorio 11: Sistema de Productos con Cupertino

Versión del laboratorio de la semana 8 desarrollada principalmente con widgets
Cupertino de Flutter para dar a la interfaz el estilo de iOS.

## Funciones

- Inicio de sesión con validación.
- Menú con pestañas de estilo iOS.
- Lista de productos con búsqueda, contador, detalle y eliminación.
- Registro de productos con validación e imagen opcional.
- Perfil editable con foto, color de tema y control de notificaciones.
- Cierre de sesión.

Los productos y ajustes se guardan temporalmente en memoria mientras la app
permanece abierta, igual que en el laboratorio original.

## Usuario de prueba

- Correo: `admin@demo.com`
- Contraseña: `123456`

## Ejecutar en tu Chrome habitual

Desde esta carpeta:

```bash
flutter pub get
flutter run -d web-server --web-hostname=127.0.0.1 --web-port=7358
```

Abre `http://127.0.0.1:7358/` en una pestaña de Chrome. Para detener el
servidor, vuelve a la terminal y pulsa `Ctrl+C`.

## Comprobaciones

```bash
flutter analyze
flutter test
flutter build web
```

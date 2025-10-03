# MensajeriaApp

Una aplicación de mensajería en tiempo real construida con Flutter, diseñada para conectar usuarios de manera rápida y eficiente.

---

## Características

* **Mensajes en tiempo real**: Envía y recibe mensajes al instante.
* **Interfaz de usuario intuitiva**: Diseño limpio y fácil de usar.
* **Autenticación segura**: Registro e inicio de sesión de usuarios con Firebase con SMS.
* **Notificaciones push**: Recibe alertas de nuevos mensajes, incluso cuando la aplicación está cerrada.

---

## Cómo empezar

Sigue estos pasos para tener una copia del proyecto funcionando en tu máquina local.

### Prerrequisitos

Asegúrate de tener instalado lo siguiente:

* **Flutter SDK**: [Guía de instalación](https://flutter.dev/docs/get-started/install)
* **Un editor de código**: Como VS Code o Android Studio.
* **Una cuenta de Firebase**: Ser invitado al proyecto por un administrador
* **Node.js + npm**: Para usar la CLI de Firebase [Descargar](https://nodejs.org/es)
* **Firebase CLI**: Se instala con:
    ```bash
    npm install -g firebase-tools
    ```
* **FlutterFire CLI**: Se instala con:
    ```bash
    dart pub global activate flutterfire_cli
    ```

### Instalación

1.  Clona el repositorio:
    ```bash
    git clone [Zaap](https://github.com/ItsRaven-13/messaging_app.git)
    ```
2.  Navega a la carpeta del proyecto:
    ```bash
    cd messaging_app
    ```
3.  Instala las dependencias:
    ```bash
    flutter pub get
    ```

### Conexión con Firebase

1.  Solicita acceso al proyecto Firebase
Un administrador debe invitarte desde la consola de Firebase:  

**Configuración del proyecto** > **Permisos** > **Agregar miembro**

Usa la misma cuenta de Google que usarás para firebase login.

2.  Inicia sesión en Firebase CLI
    ```bash
    firebase login
    ```
3.  Vincula el proyecto local con Firebase
    ```bash
    firebase use --add
    ```
Selecciona el proyecto de Firebase correspondiente

4.  Configura FlutterFire
    ```bash
    flutterfire configure
    ```

Esto generará automáticamente:

* android/app/**google-services.json**
* ios/Runner/**GoogleService-Info.plist**
* lib/**firebase_options.dart**

### Ejecutar la app

Una vez configurado, puedes ejecutar la app en tu dispositivo o emulador:
    ```bash
    flutter run
    ```

---

## Tecnologías utilizadas

* **Flutter**: El framework de UI
* **Firebase**: La plataforma de backend (Firestore, Authentication, Messaging)

---

## Autores

* **[Huapilla Pérez Esteba]** - Desarrollador - [ItsRaven-13](https://github.com/ItsRaven-13)

* **[Barrera Sánchez Uriel]** - Desarrollador - [Barrera1712](https://github.com/Barrera1712)

---

## Licencia

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE.md](LICENSE.md) para más detalles.
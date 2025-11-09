# Autores
Desarrollado por Martín Acevedo - Nicolás Corvalán

# Ship Tracker
Aplicación móvil desarrollada en Flutter para el seguimiento de pedidos y gestión de entregas. Permite visualizar el estado de los pedidos, realizar nuevos, consultar el historial y editar el perfil del usuario.

# Instalación y ejecución - Requisitos previos
- Tener instalado [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio o VS Code con el plugin de Flutter
- Un dispositivo Android o emulador configurado

# Pasos para ejecutar el proyecto
1. Clonar el repositorio:
  git clone https://github.com/xKorvii/ship_tracker
  cd ship_tracker
2. Instalar dependencias
  flutter pub get
3. Ejecutar la app
  flutter run

# ¿Cómo probar la aplicación?
1. Inicia sesión o registra un usuario. Usuario de prueba = Correo: nico@gmail.com, Contraseña: 12345678
2. Explora la pantalla principal y revisa los pedidos disponibles.
3. Visualiza el panel para crear un nuevo pedido con el botón central del menú inferior.
4. Visualiza la vista para editar tu perfil desde el icono de usuario.
5. Visualiza y confirma/cancela pedidos desde el historial.

# Decisiones de diseño
- Enfoque en la experiencia de usuario: Se priorizó una interfaz limpia, con botones e íconos claros, para que cualquier usuario pueda entender rápidamente cómo moverse por la aplicación.
- Paleta de colores moderna (../theme): Se utilizó el verde principal #15A77F(verde) para transmitir confianza y acción, acompañado de tonos oscuros #0E0E2D(azulOscuro) para equilibrio y contraste.
- Reutilización de componentes (../components): Se diseñaron elementos reutilizables como botones, campos de texto y tarjetas de pedidos , con el fin de mantener un estilo uniforme y facilitar cambios globales.
- Flujo de navegación: Las transiciones entre pantallas fueron pensadas para que permita moverse sin complicaciones entre inicio, historial, creación de pedidos o perfil.
- Animaciones: Se añadieron pequeñas animaciones en los mensajes de confirmación o cancelación, aportando una experiencia más interactiva.








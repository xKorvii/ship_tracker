# Ship Tracker

Ship Tracker es una aplicación móvil desarrollada en Flutter diseñada para optimizar la logística de última milla. Permite a los repartidores y administradores gestionar pedidos, visualizar rutas en mapas interactivos, consultar estadísticas de rendimiento y mantener un registro detallado de las entregas.

## Autores
Desarrollado por:
* Martín Acevedo
* Nicolás Corvalán

---

## Características Principales

### Autenticación y Perfil
* Login y Registro: Sistema seguro utilizando Supabase Auth.
* Gestión de Perfil: Edición de datos personales (Nombre, RUT con validador chileno, Teléfono).
* Avatar: Subida de fotos de perfil utilizando la cámara o galería (almacenamiento en Supabase Storage).

### Gestión de Pedidos
* Creación de Pedidos: Formulario intuitivo para ingresar nuevos envíos.
* Selector de Ubicación (Map Picker): Integración con OpenStreetMap (flutter_map) para seleccionar el punto exacto de entrega mediante geocodificación inversa (convierte coordenadas a dirección).
* Estados de Pedido: Flujo completo de estados: Pendiente -> Completado o Cancelado.
* Historial: Visualización de pedidos pasados con filtros de búsqueda por ID/Nombre y ordenamiento por fecha.

### Dashboard y Estadísticas
* Resumen Semanal: Gráficos de barras (fl_chart) mostrando el rendimiento de los últimos 7 días.
* Métricas Clave: Contadores de pedidos completados, pendientes y cancelados.
* Tasa de Éxito: Gráfico de línea que muestra la evolución de la eficiencia mensual.

### UI/UX
* Diseño Moderno: Paleta de colores consistente (Verde #15A77F y Azul Oscuro #0E0E2D).
* Feedback Visual: Animaciones de éxito/error al completar acciones.
* Componentes Reutilizables: Arquitectura modular de widgets.

---

## Tecnologías y Librerías

El proyecto está construido sobre Flutter (Dart) y utiliza las siguientes dependencias clave:

* Gestión de Estado: provider (Patrón Provider para Orders y User).
* Backend & Base de Datos: supabase_flutter (PostgreSQL + Auth + Storage).
* Mapas y Geolocalización:
    * flutter_map: Renderizado de mapas (OpenStreetMap).
    * latlong2: Manejo de coordenadas.
    * geocoding: Geocodificación directa e inversa.
    * location: Acceso al GPS del dispositivo.
* Gráficos: fl_chart para la visualización de datos estadísticos.
* Utilidades:
    * image_picker: Selección de imágenes.
    * google_fonts: Tipografía (Inter y Archivo Black).
    * intl: Formateo de fechas.

---

## Estructura del Proyecto

El código fuente se encuentra organizado siguiendo una arquitectura limpia y modular dentro de la carpeta lib/:

lib/
├── components/      # Widgets reutilizables (Botones, Inputs, Tarjetas, Modales)
├── models/          # Modelos de datos (OrderModel)
├── pages/           # Pantallas de la aplicación (Home, Login, Mapas, Stats)
├── providers/       # Lógica de negocio y estado (OrderProvider, UserProvider)
├── theme/           # Configuración de estilos y colores
├── utils/           # Validadores, formateadores (RUT) y manejo de errores
└── main.dart        # Punto de entrada e inicialización de Supabase

---

## Configuración e Instalación

### Requisitos Previos
* Tener instalado Flutter SDK.
* Android Studio o VS Code con el plugin de Flutter.
* Un dispositivo Android o emulador configurado.
* Un proyecto en Supabase configurado.

### Pasos para ejecutar el proyecto

1. Clonar el repositorio:
  git clone https://github.com/xKorvii/ship_tracker
  cd ship_tracker

2. Instalar dependencias
  flutter pub get

3. Configurar Supabase:
    Asegúrate de que la URL y la Anon Key en lib/main.dart correspondan a tu proyecto de Supabase. Además, debes crear la siguiente estructura en tu base de datos:

    * Tabla orders:
        * id (int8, primary key)
        * user_id (uuid, foreign key a auth.users)
        * code (text)
        * address (text)
        * status (text)
        * client_name (text)
        * client_rut (text)
        * delivery_window (text)
        * notes (text)
        * latitude (float8)
        * longitude (float8)
        * created_at (timestamptz)

    * Storage Bucket: Crear un bucket público llamado avatars.

4. Ejecutar la app
  flutter run

---

## Cómo probar la aplicación

1. Inicia sesión o registra un usuario. Usuario de prueba = Correo: nico@gmail.com, Contraseña: 12345678
2. Explora la pantalla principal y revisa los pedidos disponibles.
3. Visualiza el panel para crear un nuevo pedido con el botón central del menú inferior.
4. Visualiza la vista para editar tu perfil desde el icono de usuario.
5. Visualiza y confirma/cancela pedidos desde el historial.

---

## Licencia
Este proyecto es de uso académico y demostrativo. Todos los derechos reservados por los autores.
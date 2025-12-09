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

El código fuente se encuentra organizado siguiendo una arquitectura limpia y modular dentro de la carpeta `lib/`:

```text
lib/
├── components/      # Widgets reutilizables (Botones, Inputs, Tarjetas, Modales)
├── models/          # Modelos de datos (OrderModel)
├── pages/           # Pantallas de la aplicación (Home, Login, Mapas, Stats)
├── providers/       # Lógica de negocio y estado (OrderProvider, UserProvider)
├── theme/           # Configuración de estilos y colores
├── utils/           # Validadores, formateadores (RUT) y manejo de errores
└── main.dart        # Punto de entrada e inicialización de Supabase
```

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

1. **Registro de Usuario:**
   * En la pantalla de bienvenida, presiona el botón "Registrarse".
   * Completa el formulario con tus datos personales (Nombre, Apellido, RUT válido, Teléfono, Correo electrónico y Contraseña).
   * Al finalizar el registro, el sistema enviará automáticamente un correo de confirmación.
   * **Importante:** Debes ingresar a tu bandeja de entrada y verificar tu cuenta a través del enlace recibido antes de poder iniciar sesión.

2. **Inicio de Sesión:**
   * Una vez confirmada tu cuenta, regresa a la pantalla de Login.
   * Ingresa tus credenciales (correo y contraseña) para acceder a la aplicación.

3. **Crear un Nuevo Pedido:**
   * Pulsa el botón flotante (+) ubicado en el centro de la barra inferior.
   * Completa el formulario con los datos del cliente.
   * Toca el mapa para abrir el selector, elige un punto de entrega exacto y guarda el pedido.

4. **Gestionar Pedidos Pendientes (Inicio):**
   * En la pantalla de Inicio (Home), verás la lista de pedidos con estado "Pendiente".
   * Toca cualquier tarjeta para ver el detalle completo y la ubicación en el mapa.
   * Utiliza los botones "Confirmar" o "Cancelar" dentro del detalle para finalizar el proceso de entrega.

5. **Consultar Historial:**
   * Ve a la pestaña Historial (segundo icono en la barra de navegación).
   * Aquí aparecerán los pedidos que ya fueron procesados (Completados o Cancelados). Puedes usar la barra de búsqueda o los filtros de ordenamiento para localizarlos.

6. **Ver Estadísticas:**
   * Navega a la pestaña de Estadísticas para visualizar el resumen semanal de pedidos y la tasa de éxito mensual.

7. **Editar Perfil:**
   * Accede a la pestaña Perfil.
   * Puedes modificar tus datos personales, actualizar tu contraseña o tocar tu avatar para subir una nueva foto de perfil desde la cámara o galería.

---

## Licencia
Este proyecto es de uso académico y demostrativo. Todos los derechos reservados por los autores.
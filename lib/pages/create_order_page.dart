import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/components/text_field.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/theme/theme.dart';
import '../components/button.dart';
import 'package:provider/provider.dart'; 
import 'package:ship_tracker/providers/order_provider.dart';
import 'package:ship_tracker/utils/rut_formatter.dart';
import 'package:latlong2/latlong.dart';      
import 'package:geocoding/geocoding.dart';   
import 'map_picker_page.dart';             


class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _rutController = TextEditingController();
  final _timeController = TextEditingController(); 
  final _notesController = TextEditingController();

  final _idKey = GlobalKey<CustomTextFieldState>();
  final _nameKey = GlobalKey<CustomTextFieldState>();
  final _rutKey = GlobalKey<CustomTextFieldState>();
  final _timeKey = GlobalKey<CustomTextFieldState>();
  final _notesKey = GlobalKey<CustomTextFieldState>();

  bool _isSaving = false;
  LatLng? _selectedLatLng;
  String _addressText = ''; 

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _rutController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTimeRange(BuildContext context) async {
    final TimeOfDay? fromTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Selecciona la hora de inicio',
      confirmText: 'Siguiente',
      cancelText: 'Cancelar',
    );

    if (fromTime != null) {
      final TimeOfDay? toTime = await showTimePicker(
        context: context,
        initialTime: fromTime.replacing(
          hour: (fromTime.hour + 1) % 24,
        ),
        helpText: 'Selecciona la hora de término',
        confirmText: 'Confirmar',
        cancelText: 'Cancelar',
      );

      if (toTime != null) {
        final fromFormatted = fromTime.format(context);
        final toFormatted = toTime.format(context);

        setState(() {
          _timeController.text = "$fromFormatted - $toFormatted";
        });
      }
    }
  }

  // Abre pantalla para seleccionar mapa
  void _pickLocation() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );

    if (pickedLocation != null) {
      setState(() {
        _selectedLatLng = pickedLocation;
        _addressText = 'Procesando dirección...';
      });

      // geocodificacion inversa 
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pickedLocation.latitude,
          pickedLocation.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final address = '${place.thoroughfare ?? ''} ${place.name ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
          setState(() {
            _addressText = address.trim().isEmpty ? 'Ubicación precisa seleccionada' : address;
          });
        }
      } catch (e) {
        setState(() {
          _addressText = 'Coordenadas: ${pickedLocation.latitude.toStringAsFixed(4)}, ${pickedLocation.longitude.toStringAsFixed(4)}';
        });
      }
    }
  }

  Future<void> _saveOrder() async {
    final errors = [
      _idKey.currentState?.validate(),
      _nameKey.currentState?.validate(),
      _rutKey.currentState?.validate(),
      _timeKey.currentState?.validate(),
    ];

    if (errors.any((e) => e != null) || _selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos y selecciona una ubicación.'),
          backgroundColor: rojo,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final placemarks = await placemarkFromCoordinates(
        _selectedLatLng!.latitude,
        _selectedLatLng!.longitude,
      );

      String finalAddress = "Dirección desconocida";

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        finalAddress =
            "${p.street ?? ''} ${p.name ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}".trim();
      }


      await Provider.of<OrderProvider>(context, listen: false).addOrder(
        code: _idController.text.trim(),
        address: finalAddress,
        clientName: _nameController.text.trim(),
        clientRut: _rutController.text.trim(),
        deliveryWindow: _timeController.text.trim(),
        notes: _notesController.text.trim(),
        latitude: _selectedLatLng!.latitude,
        longitude: _selectedLatLng!.longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Pedido guardado exitosamente!"), backgroundColor: verdeClaro),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e"), backgroundColor: rojo),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: blanco,
        appBar: AppBar(
          backgroundColor: verde,
          foregroundColor: blanco,
          elevation: 0,
          title: Text(
            'Nuevo pedido',
            style: GoogleFonts.archivoBlack(
              fontSize: 20,
              color: blanco,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Datos del cliente',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 20,
                        color: negro,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      key: _idKey,
                      labelText: '#ID del pedido',
                      controller: _idController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El ID del pedido es obligatorio.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      key: _nameKey,
                      labelText: 'Nombre completo',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      key: _rutKey,
                      labelText: 'Rut del cliente',
                      controller: _rutController,
                      inputFormatters: [
                        RutFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El RUT es obligatorio.';
                        }
                        if (!RegExp(r'^(\d{1,2}\.\d{3}\.\d{3}-[\dkK])$').hasMatch(value)) {
                          return 'Formato de RUT inválido (ej: 12.345.678-9).';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Datos de entrega',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 20,
                        color: negro,
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _pickLocation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedLatLng == null ? gris : verde),
                          borderRadius: BorderRadius.circular(10),
                          color: blanco,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.map, 
                              color: _selectedLatLng == null ? grisOscuro : verde
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedLatLng == null 
                                    ? 'Toca para seleccionar ubicación en el mapa *'
                                    : _addressText.isEmpty ? 'Ubicación seleccionada' : _addressText,
                                style: TextStyle(
                                  color: _selectedLatLng == null ? grisOscuro : negro,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => _selectTimeRange(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          key: _timeKey,
                          labelText: 'Horario de entrega (rango)',
                          controller: _timeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Debes seleccionar un rango horario.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Detalles adicionales',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 20,
                        color: negro,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      key: _notesKey,
                      labelText: 'Notas adicionales',
                      controller: _notesController,
                      maxLines: 4,
                      validator: (_) => null, 
                    ),

                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Guardar pedido',
                      backgroundColor: verde,
                      textColor: blanco,
                      onPressed: _isSaving ? null : _saveOrder,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Cancelar',
                      backgroundColor: blanco,
                      textColor: rojo,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (_isSaving)
              Container(
                color: Colors.black.withAlpha(128),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
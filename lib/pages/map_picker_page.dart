import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import '../components/button.dart'; 
import '../theme/theme.dart';

// Coordenada inicial de ejemplo
const LatLng initialCenter = LatLng(-35.4360031,-71.6276026);

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng selectedLocation = initialCenter;
  String addressDisplay = 'Mueve el mapa para seleccionar la ubicación';
  bool _isLoading = false;

  void _updateLocation(LatLng newLocation) {
    setState(() {
      selectedLocation = newLocation;
      addressDisplay = 'Ubicación marcada. Cargando dirección...';
      _reverseGeocode(newLocation);
    });
  }

  Future<void> _reverseGeocode(LatLng location) async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = '${place.thoroughfare ?? ''} ${place.name ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
        setState(() {
          addressDisplay = address.trim().isEmpty ? 'Ubicación precisa seleccionada' : address;
        });
      } else {
        setState(() {
          addressDisplay = 'Coordenadas: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      setState(() {
        addressDisplay = 'No se pudo cargar la dirección. Usando coordenadas.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  void initState() {
    super.initState();
    _reverseGeocode(initialCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
        backgroundColor: verde,
        foregroundColor: blanco,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  _updateLocation(position.center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ship_tracker',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: selectedLocation, 
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 6),
                ],
              ),
              child: _isLoading 
                  ? const LinearProgressIndicator() 
                  : Text(
                      addressDisplay,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: CustomButton( 
              onPressed: () {
                Navigator.pop(context, selectedLocation);
              },
              text: 'Confirmar Ubicación',
            ),
          ),
        ],
      ),
    );
  }
}
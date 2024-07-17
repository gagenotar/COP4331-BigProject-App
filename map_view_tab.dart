import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapViewTab extends StatefulWidget {
  @override
  _MapViewTabState createState() => _MapViewTabState();
}

class _MapViewTabState extends State<MapViewTab> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(37.7749, -122.4194);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;

  String apiKey = 'AIzaSyBHL26vTrqwYjASd4O4HNh9aljV24Pm3N0'; // Replace with your API key

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _getPlaceCoordinates(String placeName) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=geometry&key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['candidates'].isNotEmpty) {
        final location = jsonResponse['candidates'][0]['geometry']['location'];
        final LatLng coordinates = LatLng(location['lat'], location['lng']);

        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(placeName),
            position: coordinates,
            infoWindow: InfoWindow(
              title: placeName,
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
          _lastMapPosition = coordinates;
        });

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(coordinates));
      } else {
        print('No results found for the place name.');
      }
    } else {
      throw Exception('Failed to load place coordinates');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController placeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: placeController,
              decoration: InputDecoration(
                hintText: 'Enter place name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _getPlaceCoordinates(placeController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                _getPlaceCoordinates(value);
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers,
              onCameraMove: (CameraPosition position) {
                _lastMapPosition = position.target;
              },
            ),
          ),
        ],
      ),
    );
  }
}

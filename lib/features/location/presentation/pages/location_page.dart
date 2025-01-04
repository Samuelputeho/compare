import 'dart:convert';
import 'package:compareitr/features/card/presentation/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class LocationSelectionPage extends StatefulWidget {
  final double totalPrice;
  final LatLng townCenter;

  const LocationSelectionPage({
    super.key,
    required this.totalPrice,
    required this.townCenter,
  });

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> 
    with SingleTickerProviderStateMixin {
  // Initial coordinates (set to the center of the map)
  LatLng _center = LatLng(51.509, -0.128);
  double _zoom = 13.0;

  // Variable to store the selected location
  LatLng? _selectedLocation;

  // Variables to store user inputs for street name and location
  String _streetName = '';
  String _locationName = '';
  String _houseNumber = ''; // New variable for house number/complex number

  // Variable to store the delivery fee
  double _deliveryFee = 50.0;

  // Add this near the top of _LocationSelectionPageState class
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to handle location selection and populate fields
  void _onTap(LatLng latLng) async {
    setState(() {
      _selectedLocation = latLng;
    });

    // Fetch street name and location name using reverse geocoding
    await _fetchAddressFromCoordinates(latLng);

    // Calculate the delivery fee based on distance (using Haversine formula or simple distance calculation)
    _deliveryFee = _calculateDeliveryFee(latLng);
  }

  // Function to fetch address (street and location) based on coordinates
  Future<void> _fetchAddressFromCoordinates(LatLng latLng) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json&addressdetails=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Get the street name and location name (suburb/neighbourhood) from the response
          _streetName = data['address']['road'] ?? 'Unknown Street';

          // Try to fetch the location name based on specific address fields
          _locationName = data['address']['suburb'] ?? 
                          data['address']['neighbourhood'] ?? 
                          data['address']['village'] ?? 
                          data['address']['city'] ?? 
                          'Unknown Location';
        });
      } else {
        throw Exception('Failed to fetch address');
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        _streetName = 'Unknown Street';
        _locationName = 'Unknown Location';
      });
    }
  }

  // Function to calculate the delivery fee based on the distance between the town center and selected location
  double _calculateDeliveryFee(LatLng selectedLocation) {
    final Distance distance = Distance();
    double distanceInMeters = distance.as(LengthUnit.Meter, widget.townCenter, selectedLocation);

    // Delivery fee increases by $1 for every 1000 meters (this is an example, adjust logic as needed)
    double deliveryFee = 50.0 + (distanceInMeters / 1000) * 5.0;
    return deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: Column(
        children: [
          // Display the map
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: widget.townCenter, // Set the center based on passed parameter
                zoom: _zoom, // Set initial zoom level
                onTap: (tapPosition, point) {
                  // Update the selected location when tapped on the map
                  _onTap(point);
                },
              ),
              children: [
                // Tile layer for OpenStreetMap tiles
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                // Marker layer to show the selected location
                MarkerLayer(
                  markers: _selectedLocation != null
                      ? [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _selectedLocation!,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          // Display total and delivery fee
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: N\$${widget.totalPrice.toStringAsFixed(2)}', // Use passed totalPrice
                  style: TextStyle(fontSize: 16, ),
                ),
                SizedBox(height: 10),
                Text(
                  'Delivery Fee: N\$${_deliveryFee.toStringAsFixed(2)}', // Display dynamic delivery fee
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Overall Price: N\$${(widget.totalPrice + _deliveryFee).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Input for street name
                TextField(
                  decoration: InputDecoration(
                    labelText: "Street Name",
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: _streetName),
                  onChanged: (value) {
                    setState(() {
                      _streetName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Input for location name
                TextField(
                  decoration: InputDecoration(
                    labelText: "Location Name",
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: _locationName),
                  onChanged: (value) {
                    setState(() {
                      _locationName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Input for house number/complex number
                TextField(
                  decoration: InputDecoration(
                    labelText: "House/Complex Number",
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: _houseNumber),
                  onChanged: (value) {
                    setState(() {
                      _houseNumber = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                // Button to confirm location
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ElevatedButton(
                       onPressed: () {
    if (_selectedLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            totalAmount: widget.totalPrice + _deliveryFee,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a location on the map")),
      );
    }
  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTween(
                          begin: Colors.green,
                          end: Colors.black,
                        ).evaluate(_controller),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm Location',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

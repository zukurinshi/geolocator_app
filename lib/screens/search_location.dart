import 'package:assignment_6/screens/home.dart';
import 'package:assignment_6/screens/weather.dart';
import 'package:assignment_6/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _currentAddress = "";
  static final initialPosition = LatLng(16.00992213719654, 120.74407936136255);
  LatLng? selectedPosition;
  String? selectedLocationName;
  late GoogleMapController mapController;
  Set<Marker> markers = {
    Marker(
      markerId: MarkerId("1"),
      position: initialPosition,
    ),
  };

  //Weather Data Fetchin function
  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  //Selected Location Function
  void SelectedLocation(LatLng position) async {
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId('$position'),
      position: position,
    ));
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String? address =
            placemark.name ?? placemark.locality ?? placemark.country;
        setState(() {
          selectedPosition = position;
          selectedLocationName = address;
        });
      }
    } catch (e) {
      print("Error fetching address location: $e");
      setState(() {
        selectedPosition = position;
        selectedLocationName = 'Location name not available';
      });
    }
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hiker\'s watch',
          style: TextStyle(color: Colors.blue),
        ),
        leading: Image(image: AssetImage('images/watch.png')),
        elevation: 1,
        shadowColor: Color.fromARGB(255, 56, 15, 151),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              markers: markers,
              onTap: (position) {
                print(position);
                SelectedLocation(position);
              },
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
            if (selectedPosition != null && selectedLocationName != null)
              Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(12.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedLocationName ??
                                  'Location name not available',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.5),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  selectedPosition = null;
                                  selectedLocationName = null;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.5,
                        ),
                        Text(
                          'Latitude: ${selectedPosition!.latitude}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 8.5,
                        ),
                        Text(
                          'Longitude: ${selectedPosition!.longitude}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 12.5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (selectedPosition != null) {
                                _fetchWeatherData(selectedPosition!.latitude,
                                    selectedPosition!.longitude);
                              } else {
                                // Handle case when no location is selected
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('No location selected'),
                                    content: Text(
                                        'Please select a location to view weather data.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              print('Button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: Text(
                              'Show weather data',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.25),
                            )),
                        SizedBox(height: 8.15),
                        if (_weather != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Icon(Icons.thermostat,color: Colors.red,),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.thermostat,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                tooltip: 'Temperature',
                              ),
                              Text(
                                '${_weather!.temperature!.celsius?.toStringAsFixed(2)}°C',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.water_drop,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                tooltip: 'Humidity',
                              ),
                              Text(
                                '${_weather!.humidity}%',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5),
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.air,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                tooltip: 'Wind Speed',
                              ),
                              Text(
                                '${_weather!.windSpeed} m/s',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5),
                              )
                            ],
                          ),
                      ],
                    ),
                  ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.blue),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (_selectedIndex) {
              case 0:
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SearchLocation()));
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            WeatherHome(currentAddress: _currentAddress)));
                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.location_pin,
                ),
                label: 'Location'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sunny,
              ),
              label: 'Weather',
            ),
          ]),
    );
  }
}

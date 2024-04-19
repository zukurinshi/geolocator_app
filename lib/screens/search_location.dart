import 'package:assignment_6/screens/home.dart';
import 'package:assignment_6/screens/weather.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  String _currentAddress = "";
  static final initialPosition = LatLng(16.00992213719654, 120.74407936136255);
  late GoogleMapController mapController;
  Set <Marker> markers = {
    Marker(
      markerId: MarkerId("1"),
      position: initialPosition,
    ),
  };

  //Selected Location Function
  void SelectedLocation (LatLng position) {
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId('$position'),
      position: position,
    ));
    CameraPosition cameraPosition = CameraPosition(target: position,zoom: 15);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );
    setState(() {
      
    });
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
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(target: initialPosition,zoom: 15),
          markers: markers,
          onTap: (position){
            print(position);
            SelectedLocation(position);
          },
          onMapCreated: (controller){
            mapController = controller;
          },
          
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

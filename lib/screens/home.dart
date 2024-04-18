import 'package:assignment_6/screens/search_location.dart';
import 'package:assignment_6/screens/weather.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Position? _currentlocation;
  String _currentaddress = "";
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentlocation!.latitude, _currentlocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentaddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Column(
              children: [
                Text(
                  'Location Coordinates',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 12.5,
                ),
                Text(
                  'Latitude: ${_currentlocation?.latitude}',
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19),
                ),
                SizedBox(
                  height: 12.5,
                ),
                Text(
                  "Longitude: ${_currentlocation?.longitude}",
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19),
                ),
                SizedBox(
                  height: 29.5,
                ),
                Text(
                  'Location Address',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 12.5,
                ),
                Text(
                  'Address: ${_currentaddress}',
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19,),
                ),
                SizedBox(
                  height: 23.5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _currentlocation = await _determinePosition();
                    await _getAddressFromCoordinates();
                    print("${_currentlocation}");
                    print("${_currentaddress}");
                  },
                  child: Text('Show current location',style: TextStyle(fontSize: 17.5),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(18.5),
                  ),
                ),
              ],
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
            switch(_selectedIndex) {
              case 0:
              Navigator.push(context,MaterialPageRoute(builder: (_) => HomePage()));
              break;
              case 1:
              Navigator.push(context,MaterialPageRoute(builder: (_) => SearchLocation()));
              break;
              case 2:
              Navigator.push(context,MaterialPageRoute(builder: (_) => WeatherHome(currentAddress: _currentaddress)));
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

import 'package:assignment_6/screens/home.dart';
import 'package:assignment_6/screens/weather.dart';
import 'package:flutter/material.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  String _currentAddress = "";
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
      body: Center(),
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
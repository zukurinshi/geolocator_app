import 'package:assignment_6/screens/home.dart';
import 'package:assignment_6/screens/search_location.dart';
import 'package:assignment_6/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherHome extends StatefulWidget {
  final String currentAddress;
  const WeatherHome({Key? key, required this.currentAddress}) : super(key: key);

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  // Position? _currentLocation;
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        // _currentLocation = position;
        _fetchWeatherData(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

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

  int _selectedIndex = 2;
  String getWeatherImage(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case 'thunderstorm':
        return 'images/thunderstorm.png';
      case 'rain':
        return 'images/rain.png';
      case 'shower rain':
        return 'images/rain.png';
      case 'broken clouds':
        return 'images/cloudy.png';
      case 'clear sky':
        return 'images/sunny.png';
      case 'few clouds':
        return 'images/cloudy.png';
      case 'scattered clouds':
        return 'images/cloudy.png';
      default:
        return 'null';
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
      body: Center(
        child: _weather != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 55.0,
                  ),
                  Text(
                    '${widget.currentAddress}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${_weather!.temperature!.celsius?.toStringAsFixed(2)}°C',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 42.5),
                  ),
                  SizedBox(height: 8),
                  Image.asset(
                    getWeatherImage(_weather!.weatherDescription ?? ''),
                    width: 115,
                    height: 115,
                  ),
                  Text(
                    '${_weather!.weatherDescription}',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(15.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop,color: Colors.blue,),
                        SizedBox(width: 12.5,),
                        Text(
                          'Humidity: ${_weather!.humidity}%',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.air,color: Colors.green,),
                        SizedBox(width: 12.5,),
                        Text(
                          'Wind Speed: ${_weather!.windSpeed} m/s',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.5),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(
                color: Colors.blue,
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

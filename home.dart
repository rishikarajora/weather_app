//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/constants.dart';
import 'package:project_app/models/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_app/widgets/weatherItem.dart';
import 'package:project_app/ui/detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  //initiatilization
  int temperature = 0;
  int MaxTemp = 0;
  String weatherStatename = 'Loading..';
  int humidity = 0;
  int windspeed = 0;

  var currentDate = 'Loading..';
  String imageUrl = ' ';
  int woied = 44418; //This is the where on Earth Id for London which is our default city
  String location = 'London'; //Our default city

  //get the cities and selected cities data
  var selectedCities = City.getSelectedCities();
  List<String> cities = ['London']; //The list of hold our selected cities, Default is London

  List consolidatedWeatherList = []; //To hold our weather data after api call

  //Api Calls 
  String searchLocationUrl = 'https://www.metaweather.com/api/location/search/?query=';   //To get the woied
  String searchWeatherUrl = 'https://www.mwtaweather.com/api/location/';

  //Get the where on earth id
  void fetchLocation(String location) async{
    var searchResult = await http.get(Uri.parse(searchLocationUrl + location));
    var result = json.decode(searchResult.body);
    setState(() {
      woied = result('woied');
    });
  }

  void fetchWeatherData() async{
    var weatherResult = await http.get(Uri.parse(searchWeatherUrl +woied.toString()));
    var result = json.decode(weatherResult.body);
    var consolidatedWeather = result['consolidated_weather'];

    setState(() {
      for(int i = 0; i<7; i++){
        consolidatedWeather.add(consolidatedWeather[i]);
      }

      //The index 0 refers to the first entry which is the current day. The next day all the index
    temperature = consolidatedWeather[0]['the_temp'].round();
    weatherStatename = consolidatedWeather[0]['weather_state_name'].round();
    humidity = consolidatedWeather[0]['humidity'].round();
    windspeed = consolidatedWeather[0]['wind_speed'].round();
    MaxTemp = consolidatedWeather[0]['max_tem'].round();


    //Data Formating
    var myDate = DateTime.parse(consolidatedWeather[0]['application_date']);
    currentDate = DateFormat('EEEE, d MMMM').format(myDate);

    //set the image URL
    imageUrl = weatherStatename.replaceAll('','').toLowerCase(); //remove any spaces in the weather state name 

    //and changes to lower case because that is how we have named our image

    consolidatedWeatherList = consolidatedWeather.toSet().toList(); //Remove any instances of duplicates from our
   //consoliated weather list
    });

    


  }


  @override
  void initState(){
    fetchLocation(cities[0]);
    fetchWeatherData();

    //For all the selected cities from our city model, extract the city and add it to our selected cities
    for(int i=0; i <selectedCities.length; i++){
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  //create a shadow linear gradient
  final Shader linearGradient = const LinearGradient(colors: <Color>[
    Color(0xffABCFFC), Color(0xff9AC6F3)
  ],).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0) );


  @override
  Widget build(BuildContext context) {
    //Create a size variable for the media query
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Our Profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset('assets/profile.png', width: 40, height: 40,),
              ),

              //Our Location dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/pin.png', width: 20,),
                  const SizedBox(width: 4,),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String location){
                        return DropdownMenuItem(
                          value: location ,
                          child: Text(location));
                          
                      }).toList(),
                      onChanged: (String? newValue){
                        setState((){
                          location = newValue!;
                          fetchLocation(location);
                          fetchWeatherData();
                        });
                      }
                    ),)
                ],
              )
            ],
          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),),
            Text(currentDate, style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: size.width,
              height: 150,
              decoration: BoxDecoration(
                color: myConstants.primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(.5),
                    offset: const Offset(0, 25),
                    blurRadius: 10,
                    spreadRadius: -12,
                  
                  )
                ]
              
              ),
              child: Stack(
                clipBehavior: Clip.none ,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ' '? const Text(' ') : Image.asset('assets/' + imageUrl + '.png', width: 150,),
                  ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(weatherStatename, style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ) ,),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                      child: Text(temperature.toString(), style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient,
                      ),),
                      ),
                      Text('o', style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient,
                      ),),
                    ],
                  ),
                )
                ],
              ),
            ),
            const SizedBox(
              height: 20,),
              const SizedBox(height: 50,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherItem(text: 'wind speed', value: windspeed, unit: 'km/h',imageUrl: 'assets/windspeed.png', ),
                    weatherItem(text: 'Humidity', value: humidity, unit: ' ', imageUrl: 'assets/humidity.png', ),
                    weatherItem(text: 'Temperature', value: MaxTemp, unit: 'C' , imageUrl: 'assets/temperature-Celcius.png',),
                  ],
                ),
              ),

              const SizedBox(
                height: 50,),
                const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Today', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    ),),

                    Text('Next 7 Days', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: myConstants.primaryColor,
                    ),),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Expanded(child: consolidatedWeatherList.isEmpty? Center(
                child: Text('No weather data available',
                style: TextStyle(fontSize: 16,
                color: Colors.grey),),
              )
              :ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index){
                  String today = DateTime.now().toString().substring(0,10);
                  final selectedDay = consolidatedWeatherList[index]['applicable_date'];
                  final futureWeatherName = consolidatedWeatherList[index]['weather_state_name'];
                  final weatherUrl = futureWeatherName.replaceAll('' , '').toLowerCase();

                  final parsedDate = DateTime.parse(selectedDay);
                  final newDate = DateFormat('EEE').format(parsedDate);



                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => DetailPage(
                        consolidatedWeatherList: consolidatedWeatherList,
                         selectedId: index, 
                         location:location),),);
                    },
                    child: Container(
                    padding: const EdgeInsets.symmetric(vertical:20),
                    margin: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
                    width: 80 ,
                    decoration: BoxDecoration(
                      color: selectedDay == today? myConstants.primaryColor : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: selectedDay == true ? myConstants.primaryColor: Colors.black54.withOpacity(.2),
                        ),
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${consolidatedWeatherList[index]['the_temp'].round()} C", style: TextStyle(
                            fontSize: 17,
                            color: selectedDay == today? Colors.white : myConstants.primaryColor,
                            fontWeight:  FontWeight.w500,
                        ),),
                        Image.asset('assets/$weatherUrl.png', width: 30,),
                        Text(newDate, style: TextStyle(
                          fontSize: 17,
                          color: selectedDay == today? Colors.white : myConstants.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),)
                      ],
                    ),
                  ),
                  );
                }))
          ],
        ),
        ),

        
        );
    

    
  }
}


class Weather {
  WeatherElement weather;
  double temp;
  int pressure;
  int humidity;
  double tempMin;
  double tempMax;
  double windSpeed;
  int datetime;
  String cityName;

  Weather({
    this.weather,
    this.temp,
    this.pressure,
    this.humidity,
    this.tempMin,
    this.tempMax,
    this.windSpeed,
    this.datetime,
    this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        weather: WeatherElement.fromJson(json['weather'][0]),
        temp: json['main']['temp'].toDouble(),
        pressure: json['main']['pressure'],
        humidity: json['main']['humidity'],
        tempMin: json['main']['temp_min'].toDouble(),
        tempMax: json['main']['temp_max'].toDouble(),
        windSpeed: json['wind']['speed'].toDouble(),
        datetime: json['dt'],
        cityName: json['name'],
      );
}

class WeatherElement {
  String name;
  String description;

  WeatherElement({
    this.name,
    this.description,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
        name: json['main'],
        description: json['description'],
      );
}

import 'package:flutter/material.dart';

import 'package:flutter_testing/models/weather_model.dart';
import 'package:flutter_testing/services/weather_service.dart';

class Home extends StatefulWidget {
  final WeatherService service;

  Home({
    Key key,
    this.service,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

@visibleForTesting
class _HomeState extends State<Home> {
  final TextEditingController _textEditingController;
  Weather _weather;

  _HomeState() : this._textEditingController = TextEditingController(text: '');

  void onGetWeather() async {
    Weather weather = await widget.service
        .getCurrentWeatherForecat(cityName: _textEditingController.text);

    setState(() {
      _weather = weather;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: _textEditingController,
                    onSubmitted: (_) => onGetWeather(),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  child: Text('Consultar Previsão do Tempo'),
                  padding: EdgeInsets.all(20),
                  color: Colors.blueAccent,
                  onPressed: onGetWeather,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          (_weather != null)
              ? Dismissible(
                  key: Key(_weather.id),
                  child: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Cidade: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_weather.cityName),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Temperatura: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${_weather.temp} ºC'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Velocidade do vento: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${_weather.windSpeed} m/s'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:convert';
import 'dart:async';

import 'services/coin.dart';

class TimeSeriesCoin {
  final DateTime time;
  final String value;

  TimeSeriesCoin(this.time, this.value);
}

class CoinDetail extends StatefulWidget {
  final Map arguments;

  CoinDetail(this.arguments);

  @override
  _CoinDetailState createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  Future<Coin> _coin;
  Future<List<TimeSeriesCoin>> _dataOfSevenWeeks;

  @override
  void initState() {
    super.initState();
    _coin = fetchCurrentCoinData();
    _dataOfSevenWeeks = fetchDataOfSevenWeeks();
  }

  Future<Coin> fetchCurrentCoinData() async {
    final String uri =
        'https://api.coingecko.com/api/v3/coins/${widget.arguments['coinId']}?tickers=false&community_data=false&developer_data=false&sparkline=false';

    final response = await http.get(uri);

    final Map data = json.decode(response.body);

    Coin currentCoin = new Coin(
        id: data['id'],
        name: data['name'],
        symbol: data['symbol'],
        value: data['market_data']['current_price']['try'].toString(),
        imageUrl: data['image']['large']);

    return currentCoin;
  }

  Future<List<TimeSeriesCoin>> fetchDataOfSevenWeeks() async {
    final String uri =
        'https://api.coingecko.com/api/v3/coins/${widget.arguments['coinId']}/market_chart?vs_currency=try&days=7';

    final response = await http.get(uri);

    final Map data = json.decode(response.body);

    final List<TimeSeriesCoin> timeSeries =
        data['prices'].map<TimeSeriesCoin>((point) {
      return new TimeSeriesCoin(
          new DateTime.fromMillisecondsSinceEpoch(point[0]),
          point[1].toString());
    }).toList();

    return timeSeries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('coun name here'),
        ),
        body: FutureBuilder(
          future: _coin,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          snapshot.data.imageUrl,
                          height: 60,
                          width: 60,
                        ),
                        Text(snapshot.data.value)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  FutureBuilder(
                    future: _dataOfSevenWeeks,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          width: 700,
                          height: 300,
                          child: charts.TimeSeriesChart([
                            new charts.Series<TimeSeriesCoin, DateTime>(
                                id: 'Value',
                                data: snapshot.data,
                                domainFn: (TimeSeriesCoin coin, _) => coin.time,
                                measureFn: (TimeSeriesCoin coin, _) =>
                                    double.parse(coin.value))
                          ]),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

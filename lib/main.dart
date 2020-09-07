import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'list_item.dart';
import 'coin_detail.dart';
import 'services/coin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoCoin Lister',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cyrpto Coin List'),
          backgroundColor: Colors.grey[700],
          elevation: 0,
        ),
        body: CoinList(),
      ),
      initialRoute: '/',
      routes: {
        '/coin': (context) =>
            CoinDetail(ModalRoute.of(context).settings.arguments),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/coin':
            final Map<String, String> arg = settings.arguments;
            return MaterialPageRoute(builder: (context) {
              return CoinDetail(arg);
            });

          default:
            return null;
        }
      },
    );
  }
}

class CoinList extends StatefulWidget {
  @override
  _CoinListState createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
  List<Coin> coinList;

  @override
  void initState() {
    super.initState();
    fetchtFirstFiveCoins();
  }

  void fetchtFirstFiveCoins() async {
    final response = await http.get(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=try&order=market_cap_desc&per_page=5&page=1&sparkline=false');
    List data = JsonDecoder().convert(response.body);
    List<Coin> cList = new List<Coin>();

    data.forEach((element) {
      Coin toAdd = new Coin(
          id: element['id'],
          name: element['name'],
          symbol: element['symbol'],
          value: element['current_price'].toString(),
          priceChangePercentage:
              element['price_change_percentage_24h'].toString());

      cList.add(toAdd);
    });

    setState(() {
      coinList = cList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: coinList
                ?.map((coin) => ListItem(
                    id: coin.id,
                    symbol: coin.symbol,
                    price: coin.value,
                    percentChange: coin.priceChangePercentage))
                ?.toList() ??
            []);
  }
}

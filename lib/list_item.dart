import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String id;
  final String symbol;
  final String price;
  final String percentChange;
  ListItem({this.symbol, this.price, this.percentChange, this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/coin',
            arguments: <String, String>{'coinId': id});
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${this.symbol.toUpperCase()}',
                  style: TextStyle(
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${this.price} TRY',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    '${this.percentChange}',
                    style: TextStyle(
                        color: this.percentChange[0] == '-'
                            ? Colors.red
                            : Colors.green),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

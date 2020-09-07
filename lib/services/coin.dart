class Coin {
  String id;
  String name;
  String symbol;
  String value;
  String priceChangePercentage; // 24h
  String imageUrl;

  Coin(
      {this.id,
      this.name,
      this.symbol,
      this.value,
      this.priceChangePercentage,
      this.imageUrl});
}

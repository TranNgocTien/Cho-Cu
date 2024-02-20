class Price {
  final String id;
  final String priceId;
  final String createAt;
  final String discount;
  final String distance;

  final Holiday holiday;

  final String hostId;
  final String movingFee;
  final String price;
  final String sumPrice;
  final String workDate;
  Price({
    this.id = '',
    this.priceId = '',
    this.createAt = '',
    this.discount = '0',
    this.distance = '',
    this.holiday = holidayDefault,
    this.hostId = '',
    this.movingFee = "0",
    this.price = '0',
    this.sumPrice = '0',
    this.workDate = '',
  });
}

const Holiday holidayDefault = Holiday(name: '');

class Holiday {
  final String name;

  final String value;
  final String sum;
  const Holiday({
    required this.name,
    this.value = '0',
    this.sum = '0',
  });
}

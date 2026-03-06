import 'package:equatable/equatable.dart';

class MoneyModel extends Equatable {
  final num amount;
  final String currency;

  const MoneyModel({
    required this.amount,
    required this.currency,
  });

  const MoneyModel.empty()
      : amount = 0,
        currency = '';

  factory MoneyModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const MoneyModel.empty();
    }

    return MoneyModel(
      amount: _parseNum(json['amount']),
      currency: (json['currency'] ?? '').toString().trim(),
    );
  }

  MoneyModel copyWith({
    num? amount,
    String? currency,
  }) {
    return MoneyModel(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }

  double get amountAsDouble => amount.toDouble();

  String get formatted {
    final value = amountAsDouble % 1 == 0
        ? amountAsDouble.toInt().toString()
        : amountAsDouble.toStringAsFixed(2);

    if (currency.trim().isEmpty) return value;
    return '$value $currency';
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }

  static num _parseNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [amount, currency];
}
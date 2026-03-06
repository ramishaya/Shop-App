import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String city;
  final String country;
  final String otherDetails;
  final String state;
  final String street;

  const AddressModel({
    required this.city,
    required this.country,
    required this.otherDetails,
    required this.state,
    required this.street,
  });

  const AddressModel.empty()
      : city = '',
        country = '',
        otherDetails = '',
        state = '',
        street = '';

  factory AddressModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const AddressModel.empty();
    }

    return AddressModel(
      city: (json['city'] ?? '').toString().trim(),
      country: (json['country'] ?? '').toString().trim(),
      otherDetails: (json['otherDetails'] ?? '').toString().trim(),
      state: (json['state'] ?? '').toString().trim(),
      street: (json['street'] ?? '').toString().trim(),
    );
  }

  AddressModel copyWith({
    String? city,
    String? country,
    String? otherDetails,
    String? state,
    String? street,
  }) {
    return AddressModel(
      city: city ?? this.city,
      country: country ?? this.country,
      otherDetails: otherDetails ?? this.otherDetails,
      state: state ?? this.state,
      street: street ?? this.street,
    );
  }

  String get shortAddress {
    final parts = <String>[
      street,
      city,
    ].where(_isMeaningful).toList();

    return parts.join(', ');
  }

  String get fullAddress {
    final parts = <String>[
      street,
      otherDetails,
      city,
      state,
      country,
    ].where(_isMeaningful).toList();

    return parts.join(', ');
  }

  bool get isEmpty =>
      city.isEmpty &&
      country.isEmpty &&
      otherDetails.isEmpty &&
      state.isEmpty &&
      street.isEmpty;

  bool get isNotEmpty => !isEmpty;

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'otherDetails': otherDetails,
      'state': state,
      'street': street,
    };
  }

  static bool _isMeaningful(String value) {
    final cleaned = value.trim();
    return cleaned.isNotEmpty &&
        cleaned != '-' &&
        cleaned != '--' &&
        cleaned != '---' &&
        cleaned != '----';
  }

  @override
  List<Object?> get props => [city, country, otherDetails, state, street];
}
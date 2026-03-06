import 'package:equatable/equatable.dart';

import 'address_model.dart';
import 'localized_text_model.dart';
import 'money_model.dart';

class ShopModel extends Equatable {
  final String id;
  final LocalizedTextModel shopName;
  final LocalizedTextModel description;
  final MoneyModel minimumOrder;
  final AddressModel address;
  final String estimatedDeliveryTime;
  final List<String> deliveryRegions;
  final List<String> contactInfo;
  final String ownerFullName;
  final String profilePhoto;
  final String coverPhoto;
  final String categoryType;
  final String badgeTag;
  final bool availability;
  final bool enable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShopModel({
    required this.id,
    required this.shopName,
    required this.description,
    required this.minimumOrder,
    required this.address,
    required this.estimatedDeliveryTime,
    required this.deliveryRegions,
    required this.contactInfo,
    required this.ownerFullName,
    required this.profilePhoto,
    required this.coverPhoto,
    required this.categoryType,
    required this.badgeTag,
    required this.availability,
    required this.enable,
    required this.createdAt,
    required this.updatedAt,
  });

  const ShopModel.empty()
      : id = '',
        shopName = const LocalizedTextModel.empty(),
        description = const LocalizedTextModel.empty(),
        minimumOrder = const MoneyModel.empty(),
        address = const AddressModel.empty(),
        estimatedDeliveryTime = '',
        deliveryRegions = const [],
        contactInfo = const [],
        ownerFullName = '',
        profilePhoto = '',
        coverPhoto = '',
        categoryType = '',
        badgeTag = '',
        availability = false,
        enable = false,
        createdAt = null,
        updatedAt = null;

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: (json['_id'] ?? json['id'] ?? '').toString().trim(),
      shopName: LocalizedTextModel.fromJson(json['shopName']),
      description: LocalizedTextModel.fromJson(json['description']),
      minimumOrder: MoneyModel.fromJson(json['minimumOrder']),
      address: AddressModel.fromJson(json['address']),
      estimatedDeliveryTime:
          (json['estimatedDeliveryTime'] ?? '').toString().trim(),
      deliveryRegions: _parseStringList(json['deliveryRegions']),
      contactInfo: _parseStringList(json['contactInfo']),
      ownerFullName: (json['ownerFullName'] ?? '').toString().trim(),
      profilePhoto: (json['profilePhoto'] ?? '').toString().trim(),
      coverPhoto: (json['coverPhoto'] ?? '').toString().trim(),
      categoryType: (json['categoryType'] ?? '').toString().trim(),
      badgeTag: (json['badgeTag'] ?? '').toString().trim(),
      availability: _parseBool(json['availability']),
      enable: _parseBool(json['enable']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  ShopModel copyWith({
    String? id,
    LocalizedTextModel? shopName,
    LocalizedTextModel? description,
    MoneyModel? minimumOrder,
    AddressModel? address,
    String? estimatedDeliveryTime,
    List<String>? deliveryRegions,
    List<String>? contactInfo,
    String? ownerFullName,
    String? profilePhoto,
    String? coverPhoto,
    String? categoryType,
    String? badgeTag,
    bool? availability,
    bool? enable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      address: address ?? this.address,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      deliveryRegions: deliveryRegions ?? this.deliveryRegions,
      contactInfo: contactInfo ?? this.contactInfo,
      ownerFullName: ownerFullName ?? this.ownerFullName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      categoryType: categoryType ?? this.categoryType,
      badgeTag: badgeTag ?? this.badgeTag,
      availability: availability ?? this.availability,
      enable: enable ?? this.enable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOpen => availability;
  bool get isEnabled => enable;
  bool get isDisplayable => enable;

  String get imageUrl {
    if (coverPhoto.isNotEmpty) return coverPhoto;
    if (profilePhoto.isNotEmpty) return profilePhoto;
    return '';
  }

  int get estimatedDeliveryMinutes {
    final match = RegExp(r'(\d+)').firstMatch(estimatedDeliveryTime);
    if (match == null) return 999999;
    return int.tryParse(match.group(1) ?? '') ?? 999999;
  }

  String localizedName(String localeCode) {
    return shopName.resolve(localeCode);
  }

  String localizedDescription(String localeCode) {
    return description.resolve(localeCode);
  }

  String get locationText {
    if (address.shortAddress.isNotEmpty) return address.shortAddress;
    if (address.fullAddress.isNotEmpty) return address.fullAddress;
    return '';
  }

  bool matchesQuery(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;

    final searchableParts = <String>[
      shopName.en,
      shopName.ar,
      description.en,
      description.ar,
      categoryType,
      badgeTag,
      ownerFullName,
      address.city,
      address.state,
      address.street,
      address.country,
      ...deliveryRegions,
      ...contactInfo,
    ];

    return searchableParts.any(
      (element) => element.toLowerCase().contains(query),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'shopName': shopName.toJson(),
      'description': description.toJson(),
      'minimumOrder': minimumOrder.toJson(),
      'address': address.toJson(),
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveryRegions': deliveryRegions,
      'contactInfo': contactInfo,
      'ownerFullName': ownerFullName,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
      'categoryType': categoryType,
      'badgeTag': badgeTag,
      'availability': availability,
      'enable': enable,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is num) return value == 1;
    return false;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  @override
  List<Object?> get props => [
        id,
        shopName,
        description,
        minimumOrder,
        address,
        estimatedDeliveryTime,
        deliveryRegions,
        contactInfo,
        ownerFullName,
        profilePhoto,
        coverPhoto,
        categoryType,
        badgeTag,
        availability,
        enable,
        createdAt,
        updatedAt,
      ];
}
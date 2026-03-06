import 'package:equatable/equatable.dart';

class LocalizedTextModel extends Equatable {
  final String en;
  final String ar;

  const LocalizedTextModel({
    required this.en,
    required this.ar,
  });

  const LocalizedTextModel.empty()
      : en = '',
        ar = '';

  factory LocalizedTextModel.fromJson(dynamic json) {
    if (json == null) {
      return const LocalizedTextModel.empty();
    }

    if (json is String) {
      return LocalizedTextModel(
        en: json.trim(),
        ar: json.trim(),
      );
    }

    if (json is Map<String, dynamic>) {
      return LocalizedTextModel(
        en: (json['en'] ?? '').toString().trim(),
        ar: (json['ar'] ?? '').toString().trim(),
      );
    }

    return LocalizedTextModel(
      en: json.toString().trim(),
      ar: json.toString().trim(),
    );
  }

  LocalizedTextModel copyWith({
    String? en,
    String? ar,
  }) {
    return LocalizedTextModel(
      en: en ?? this.en,
      ar: ar ?? this.ar,
    );
  }

  String resolve(String localeCode) {
    final isArabic = localeCode.toLowerCase().startsWith('ar');

    if (isArabic) {
      if (ar.isNotEmpty) return ar;
      if (en.isNotEmpty) return en;
    } else {
      if (en.isNotEmpty) return en;
      if (ar.isNotEmpty) return ar;
    }

    return '';
  }

  bool get isEmpty => en.isEmpty && ar.isEmpty;
  bool get isNotEmpty => !isEmpty;

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'ar': ar,
    };
  }

  @override
  List<Object?> get props => [en, ar];
}
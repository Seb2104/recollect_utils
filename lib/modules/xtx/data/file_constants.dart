part of '../../../recollect_utils.dart';

class FolderMeta {
  final String? customIcon;

  final Map<String, dynamic> additionalData;

  const FolderMeta({this.customIcon, this.additionalData = const {}});

  FolderMeta copyWith({
    String? customIcon,
    Map<String, dynamic>? additionalData,
  }) {
    return FolderMeta(
      customIcon: customIcon ?? this.customIcon,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (customIcon != null && customIcon!.isNotEmpty) {
      json['customIcon'] = customIcon;
    }

    if (additionalData.isNotEmpty) {
      json.addAll(additionalData);
    }

    return json;
  }

  factory FolderMeta.fromJson(Map<String, dynamic> json) {
    final customIcon = json['customIcon'] as String?;

    final additionalData = Map<String, dynamic>.from(json);
    additionalData.remove('customIcon');

    return FolderMeta(customIcon: customIcon, additionalData: additionalData);
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory FolderMeta.fromJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return FolderMeta.fromJson(json);
    } catch (e) {
      return const FolderMeta();
    }
  }

  bool get isEmpty {
    return (customIcon == null || customIcon!.isEmpty) &&
        additionalData.isEmpty;
  }

  bool get hasCustomIcon => customIcon != null && customIcon!.isNotEmpty;
}

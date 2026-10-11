class LocalUserModel {
  const LocalUserModel({required this.id, required this.createdAt});

  final String id;
  final DateTime createdAt;

  String get imageUrl => 'https://api.dicebear.com/10.x/pixelbot/svg?seed=$id';

  factory LocalUserModel.fromJson(Map<String, dynamic> json) => LocalUserModel(
    id: json['id'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String? ?? ''),
  );
}

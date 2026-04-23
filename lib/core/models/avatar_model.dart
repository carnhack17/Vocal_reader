class Avatar {
  final String id;
  final String name;
  final String imagePath;
  final String voiceType;
  final String personality; // "adventurous", "calm", "mysterious", etc.
  final List<String> bestFor; // ["fantasy", "sci-fi", "romance"]
  final double voiceSpeed;
  final String description;

  Avatar({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.voiceType,
    required this.personality,
    required this.bestFor,
    this.voiceSpeed = 1.0,
    required this.description,
  });

  // For JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imagePath': imagePath,
    'voiceType': voiceType,
    'personality': personality,
    'bestFor': bestFor,
    'voiceSpeed': voiceSpeed,
    'description': description,
  };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    id: json['id'] as String,
    name: json['name'] as String,
    imagePath: json['imagePath'] as String,
    voiceType: json['voiceType'] as String,
    personality: json['personality'] as String,
    bestFor: List<String>.from(json['bestFor'] as List),
    voiceSpeed: (json['voiceSpeed'] as num?)?.toDouble() ?? 1.0,
    description: json['description'] as String,
  );
}

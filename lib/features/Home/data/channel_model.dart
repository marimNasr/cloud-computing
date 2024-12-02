class ChannelModel {
  final String name;
  final List<String> Subscribers;
  final String owner;

  ChannelModel({required this.name, required this.Subscribers, required this.owner});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      name: json['Name'],
      Subscribers: List<String>.from(json['Subscribers']),
      owner: json['owner'],
      // Corrected line
    );
  }
}

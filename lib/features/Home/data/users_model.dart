class UserModel{
  final String name;
  final String email;

  UserModel({required this.name,required this.email});
  factory UserModel.fromJson(json){
    return UserModel(name: json['name'],email: json['email']);
  }
}
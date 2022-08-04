class Partner{
  final int partnerID;
  final String name;
  final String description;

  const Partner(this.partnerID, this.name, this.description);
  
  factory Partner.fromJson(Map<String, dynamic> json){
    return Partner(json['partnerID'] as int, json['name'] as String,
        json['description'] as String);
  }
}
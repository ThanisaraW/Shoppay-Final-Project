class BannerModel {
  final String id;
  final String imageUrl;
  final String? title;
  final String? link;
  final int order;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    required this.order,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String?,
      link: json['link'] as String?,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'link': link,
      'order': order,
    };
  }
}
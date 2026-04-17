import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  final String url;

  const CategoryModel({
    required super.slug,
    required super.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    slug: json['slug'] as String,
    name: json['name'] as String,
    url: json['url'] as String,
  );

  Map<String, dynamic> toJson() => {'slug': slug, 'name': name, 'url': url};

  @override
  List<Object?> get props => [slug, name, url];
}

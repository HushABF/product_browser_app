import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
	final String slug;
	final String name;
	final String url;

	const CategoryModel({required this.slug, required this.name, required this.url});

	factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
				slug: json['slug'] as String,
				name: json['name'] as String,
				url: json['url'] as String,
			);

	Map<String, dynamic> toJson() => {
				'slug': slug,
				'name': name,
				'url': url,
			};

	@override
	List<Object> get props => [slug, name, url];
}

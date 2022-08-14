class SpecyImage {
  String animal_id;
  String images;

  SpecyImage({required this.animal_id, required this.images});

  static SpecyImage fromJson(Map<String, dynamic> json) => SpecyImage(
        animal_id: json['animal_id'],
        images: json['images'],
      );
}

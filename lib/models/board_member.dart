// lib/models/board_member.dart

class BoardMember {
  final String name;
  final String title;
  final String? subtitle;
  final String? specialty;
  final String? organization;
  final String? location;
  final String? image;
  final String category;

  BoardMember({
    required this.name,
    required this.title,
    this.subtitle,
    this.specialty,
    this.organization,
    this.location,
    this.image,
    required this.category,
  });
}
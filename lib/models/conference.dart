import 'package:flutter/material.dart';

class Conference {
  final String id;
  final String title;
  final String titleAr;
  final String shortName;
  final DateTime date;
  final DateTime endDate;
  final String location;
  final String locationAr;
  final String description;
  final String imageUrl;
  final Color color;
  final String category;
  final int attendees;

  Conference({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.shortName,
    required this.date,
    required this.endDate,
    required this.location,
    required this.locationAr,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.category,
    required this.attendees,
  });
}

class BoardMember {
  final String name;
  final String title;
  final String image;
  final String specialty;

  BoardMember({
    required this.name,
    required this.title,
    required this.image,
    required this.specialty,
  });
}

class QuickActionItem {
  final IconData icon;
  final String title;
  final Color color;
  final String route;

  QuickActionItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.route,
  });
}
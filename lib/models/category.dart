import 'package:fyp/constants/icons.dart';

class Category {
  String thumbnail;
  String name;
  int noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Daily Schedule',
    noOfCourses: 55,
    thumbnail: icSchedule2,
  ),
  Category(
    name: 'Exam Schedule',
    noOfCourses: 20,
    thumbnail: icExam,
  ),
  // Category(
  //   name: 'Photography',
  //   noOfCourses: 16,
  //   thumbnail: 'assets/images/photography.jpg',
  // ),
  // Category(
  //   name: 'Product Design',
  //   noOfCourses: 25,
  //   thumbnail: 'assets/images/design.jpg',
  // ),
];

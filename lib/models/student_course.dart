class StudentCourse {
  StudentCourse(this.courseTimings);
  List<dynamic> courseTimings;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "courseTimings": courseTimings,
    };
  }
}

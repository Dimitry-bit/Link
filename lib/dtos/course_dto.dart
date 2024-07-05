class CourseDTO {
  String? name;
  String? code;
  String? department;
  int? creditHours;
  int? year;
  bool? hasLecture;
  bool? hasLab;
  bool? hasSection;

  CourseDTO({
    this.name,
    this.code,
    this.department,
    this.creditHours,
    this.year,
    this.hasLecture,
    this.hasLab,
    this.hasSection,
  });
}

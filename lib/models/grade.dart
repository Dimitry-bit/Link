import 'package:link/models/course.dart';
import 'package:link/models/repository_model.dart';

enum GradeTypes {
  A_PLUS,
  A,
  A_MINUS,
  B_PLUS,
  B,
  B_MINUS,
  C_PLUS,
  C,
  C_MINUS,
  D_PLUS,
  D,
  F,
}

class Grade implements RepositoryModel<Grade> {
  static final Map<GradeTypes, double> _gradeToValue = {
    GradeTypes.A_PLUS: 4.0,
    GradeTypes.A: 4.0,
    GradeTypes.A_MINUS: 3.7,
    GradeTypes.B_PLUS: 3.3,
    GradeTypes.B: 3.0,
    GradeTypes.B_MINUS: 2.7,
    GradeTypes.C_PLUS: 2.3,
    GradeTypes.C: 2.0,
    GradeTypes.C_MINUS: 1.7,
    GradeTypes.D_PLUS: 1.3,
    GradeTypes.D: 1.0,
    GradeTypes.F: 0.0,
  };

  static final Map<GradeTypes, String> _gradeToLetter = {
    GradeTypes.A_PLUS: 'A+',
    GradeTypes.A: 'A',
    GradeTypes.A_MINUS: 'A-',
    GradeTypes.B_PLUS: 'B+',
    GradeTypes.B: 'B',
    GradeTypes.B_MINUS: 'B-',
    GradeTypes.C_PLUS: 'C+',
    GradeTypes.C: 'C',
    GradeTypes.C_MINUS: 'C-',
    GradeTypes.D_PLUS: 'D+',
    GradeTypes.D: 'D',
    GradeTypes.F: 'F',
  };

  Course course;
  GradeTypes type;

  Grade(this.type, {required this.course});

  String courseName() => course.name;

  String gradeLetter() => gradeToLetter(type);

  double gradeValue() => gradeToValue(type);

  @override
  String primaryKey() => course.primaryKey();

  @override
  Grade clone() => Grade(type, course: course);

  @override
  bool operator ==(Object other) {
    return other is Grade && course == other.course && type == other.type;
  }

  @override
  int get hashCode => course.hashCode ^ type.hashCode;

  @override
  String toString() => "course: ${courseName()}, grade: $type";

  /// Returns all grade letters recognized by this system [A+, A, A-, ..., F].
  static List<String> gradeLetters() => _gradeToLetter.values.toList();

  /// Converts a [grade] into its corresponding numerical value.
  static double gradeToValue(GradeTypes grade) => _gradeToValue[grade]!;

  /// Converts a [grade] into its corresponding letter.
  static String gradeToLetter(GradeTypes grade) => _gradeToLetter[grade]!;

  /// Converts a [gradeLetter] into its corresponding grade type.
  ///
  /// Throws:
  ///   - [ArgumentError] : If [gradeLetter] is unrecognized.
  static GradeTypes letterToGrade(String gradeLetter) {
    for (var e in _gradeToLetter.entries) {
      if (e.value == gradeLetter) {
        return e.key;
      }
    }

    throw ArgumentError.value(gradeLetter, 'gradeType', 'unknown grade letter');
  }

  /// Calculates the cumulative GPA (Grade Point Average) of the given [grades].
  ///
  /// If [grades] is empty, returns '0.0'.
  static double cumulativeGPA(List<Grade> grades) {
    if (grades.isEmpty) {
      return 0.0;
    }

    double result = 0.0;
    int totalCreditHours = 0;

    for (var grade in grades) {
      result += grade.course.creditHours * gradeToValue(grade.type);
      totalCreditHours += grade.course.creditHours;
    }

    return result / totalCreditHours;
  }
}

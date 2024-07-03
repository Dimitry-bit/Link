import 'package:link/models/repository_model.dart';

class Course implements RepositoryModel {
  late String _name;
  late String _code;
  String _department;
  late int _creditHours;
  late int _year;
  bool _hasLecture;
  bool _hasLab;
  bool _hasSection;

  Course(String name, String code, String department, int creditHours, int year,
      bool hasLecture, bool hasLab, bool hasSection)
      : _department = department.trim(),
        _year = year,
        _hasLecture = hasLecture,
        _hasLab = hasLab,
        _hasSection = hasSection {
    _name = name;
    _code = code;
    _creditHours = creditHours;
    _year = year;
  }

  String get name => _name;

  set name(String name) {
    name = name.trim();

    if (name.isEmpty) {
      throw ArgumentError('course name can not be empty');
    }

    _name = name;
  }

  String get code => _code;

  set code(String code) {
    code = code.trim();

    if (code.isEmpty) {
      throw ArgumentError('course code can not be empty');
    }

    _code = code.toUpperCase();
  }

  String get department => _department;
  set department(String department) => _department = department.trim();

  int get creditHours => _creditHours;

  set creditHours(int creditHours) {
    if (creditHours < 0) {
      throw ArgumentError("course credit hours must be '>= 0'");
    }

    _creditHours = creditHours;
  }

  int get year => _year;

  set year(int year) {
    if (year <= 0) {
      throw ArgumentError("course year must be '>= 0'");
    }

    _year = year;
  }

  bool get hasLecture => _hasLecture;
  set hasLecture(bool lecture) => _hasLecture = lecture;

  bool get hasLab => _hasLab;
  set hasLab(bool lab) => _hasLab = lab;

  bool get hasSection => _hasSection;
  set hasSection(bool section) => _hasSection = section;

  Map<String, dynamic> toJson() => {
        'name': _name,
        'code': _code,
        'department': _department,
        'creditHours': _creditHours,
        'year': year,
        'hasLecture': _hasLecture,
        'hasLab': _hasLab,
        'hasSection': _hasSection,
      };

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        json['name'] as String,
        json['code'] as String,
        json['department'] as String,
        json['creditHours'] as int,
        json['year'] as int,
        json['hasLecture'] as bool,
        json['hasLab'] as bool,
        json['hasSection'] as bool);
  }

  @override
  bool operator ==(Object other) {
    return other is Course &&
        _name == other._name &&
        _code == other._code &&
        _department == other._department &&
        _creditHours == other._creditHours &&
        _year == other._year &&
        _hasLecture == other._hasLecture &&
        _hasLab == other._hasLab &&
        _hasSection == other._hasSection;
  }

  @override
  int get hashCode {
    return _name.hashCode ^
        _code.hashCode ^
        _department.hashCode ^
        _creditHours.hashCode ^
        _year.hashCode ^
        _hasLecture.hashCode ^
        _hasLab.hashCode ^
        _hasSection.hashCode;
  }

  @override
  String toString() {
    return "$_name, code: '$_code', dept: '$_department', creditHours: $_creditHours,"
        "year: $_year, (lecture, lab, section): '$_hasLecture $_hasLab, $_hasSection'";
  }

  @override
  String primaryKey() => _code;
}

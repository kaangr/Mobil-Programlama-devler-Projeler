class Person {
  final String _name;

  Person(this._name);

  String get name => _name;
}

class Secretary extends Person {
  Secretary(super._name);
  List<Teacher> teachers = [];
  List<Student> students = [];

  void addTeacher(Teacher teacher) {
    teachers.add(teacher);
  }

  void addStudent(Student student) {
    students.add(student);
  }

  void printInfo() {
    for (var teacher in teachers) {
      print('Teacher: ${teacher.name}');
    }
    for (var student in students) {
      print('Student: ${student.name}');
    }
  }
}

class Teacher extends Person {
  Teacher(super._name);

  void study([int? hours]) {
    if (hours != null) {
      print('$name is studying for $hours hours.');
    } else {
      print('$name is studying.');
    }
  }

  void giveExam() {
    print('$name is giving an exam.');
  }
}

class Student extends Person {
  Student(super._name);

  void study([int? hours]) {
    if (hours != null) {
    } else {}
  }

  void takeExam() {
    print('$name is taking an exam.');
  }
}

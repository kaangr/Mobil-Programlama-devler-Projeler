class Person {
  final String _name;

  Person(this._name);

  String get name => _name;
}

class Secretary extends Person {
  Secretary(super._name);
  List<Teacher> teachers = [];
  List<Student> students = [];
  List<String> announcements = [];

  void addTeacher(Teacher teacher) {
    teachers.add(teacher);
  }

  void addStudent(Student student) {
    students.add(student);
  }

  void addAnnouncement(String announcement) {
    announcements.add(announcement);
  }

  void removeAnnouncement(int index) {
    announcements.removeAt(index);
  }

  List<String> getAnnouncements() {
    return announcements;
  }

  void printInfo() {
    print('Duyurular:');
    for (var announcement in announcements) {
      print('- $announcement');
    }
    print('\nÖğretmenler:');
    for (var teacher in teachers) {
      print('- ${teacher.name}');
    }
    print('\nÖğrenciler:');
    for (var student in students) {
      print('- ${student.name}');
    }
  }
}

class Teacher extends Person {
  Teacher(super._name);
  Map<String, Map<String, double>> studentGrades = {};

  void addGrades(String studentName, double midterm, double final_) {
    studentGrades[studentName] = {
      'midterm': midterm,
      'final': final_,
      'average': calculateAverage(midterm, final_)
    };
  }

  double calculateAverage(double midterm, double final_) {
    return (midterm * 0.4) + (final_ * 0.6);
  }

  Map<String, double> getGrades(String studentName) {
    return studentGrades[studentName] ?? {};
  }
}

class Student extends Person {
  Student(super._name);
  List<String> todoList = [];

  void addTodo(String task) {
    todoList.add(task);
  }

  void removeTodo(int index) {
    todoList.removeAt(index);
  }

  List<String> getTodoList() {
    return todoList;
  }
}

class Course {
  int id;
  String name;
  double price;
  String techStack;

  Course(this.name, this.price, this.techStack);
  Course.withId(this.id, this.name, this.price, this.techStack);
}

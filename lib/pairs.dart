class Duo<First, Second> {
  final First first;
  final Second second;

  Duo(this.first, this.second);
}

class Trio<First, Second, Third> extends Duo<First, Second> {
  final Third third;

  Trio(First first, Second second, this.third) : super(first, second);
}
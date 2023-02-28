class Triple<T1, T2, T3>
{
  final T1 item1;
  final T2 item2;
  final T3 item3;

  const Triple(T1 item1, T2 item2, T3 item3)
      : this.item1 = item1, this.item2 = item2, this.item3 = item3;

  @override
  bool operator==(other)
  {
    if (other is !Triple)
      return false;

    return other.item1 == item1 && other.item2 == item2 && other.item3 == item3;
  }

  @override
  int get hashCode => super.hashCode;
}
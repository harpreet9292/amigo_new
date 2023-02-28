class Pair<T1, T2>
{
  final T1 item1;
  final T2 item2;

  const Pair(T1 item1, T2 item2)
      : this.item1 = item1, this.item2 = item2;

  @override
  bool operator==(other)
  {
    if (other is !Pair)
      return false;

    return other.item1 == item1 && other.item2 == item2;
  }

  @override
  int get hashCode => super.hashCode;
}
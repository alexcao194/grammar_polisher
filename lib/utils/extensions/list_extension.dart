extension ListExtension<E> on List<E> {
  Iterable<E> mapIndexed(E Function(int index, E e) f) {
    return asMap().entries.map((entry) => f(entry.key, entry.value));
  }
}
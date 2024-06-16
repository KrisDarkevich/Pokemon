abstract class RandomEvent {}

class GetRandomPokeEvent extends RandomEvent {
  final int offset;
  final int limit;

  GetRandomPokeEvent(this.offset, this.limit);
}
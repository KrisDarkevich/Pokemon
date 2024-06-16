abstract class ApiEvent {}

class GetUrlEvent extends ApiEvent {
  final int offset;
  final int limit;

  GetUrlEvent(this.offset, this.limit);
}

class SearchEvent extends ApiEvent {
  final String query;

  SearchEvent(this.query);
}
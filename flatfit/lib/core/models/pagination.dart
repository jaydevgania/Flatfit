/// Generic pagination models for cursor- or page-based API responses.
class PaginatedList<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
  final String? nextCursor;

  const PaginatedList({
    required this.items,
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.hasMore = false,
    this.nextCursor,
  });

  factory PaginatedList.empty() => const PaginatedList(
        items: [],
        page: 1,
        pageSize: 20,
        totalCount: 0,
        hasMore: false,
      );

  PaginatedList<T> copyWith({
    List<T>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? hasMore,
    String? nextCursor,
  }) {
    return PaginatedList<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  PaginatedList<R> map<R>(R Function(T item) transform) {
    return PaginatedList<R>(
      items: items.map(transform).toList(),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }
}

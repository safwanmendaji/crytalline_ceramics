class FilterRequest {
  final List<int> brandIds;
  final List<int> categoryIds;
  final String search;
  final int perPage;
  final int page;

  FilterRequest({
    required this.brandIds,
    required this.categoryIds,
    this.search = '',
    this.perPage = 10,
    this.page = 1,
  });

  // Convert FilterRequest to query parameters for the API call
  Map<String, String> toQueryParameters() {
    return {
      'brand_id': brandIds.join(','),
      'category_id': categoryIds.join(','),
      'search': search,
      'per_page': perPage.toString(),
      'page': page.toString(),
    };
  }
}

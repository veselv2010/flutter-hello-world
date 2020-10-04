enum TestType {
  normal,
  noContent,
}

Map<TestType, String> testTypes = {
  TestType.normal: 'Normal response test',
  TestType.noContent: 'No content (code 204) test',
};
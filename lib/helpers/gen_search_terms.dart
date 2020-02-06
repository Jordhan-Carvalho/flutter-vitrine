List<String> createKeywords(String searchTerm) {
  List<String> searchKeywords = [];
  var currentTerm = "", letterArr = searchTerm.split('');
  letterArr.forEach((letter) {
    currentTerm += letter;
    if (currentTerm.length > 2) {
      searchKeywords.add(currentTerm);
    }
  });
  return searchKeywords;
}

List<String> searchTerms(String stringToSearch) {
  List<String> finalTerms = [];

  var searchedArray = stringToSearch.trim().toLowerCase().split(" ");

  for (var i = 0; i < searchedArray.length; i++) {
    var dynamicString = searchedArray.join(" ");
    // push to main array
    finalTerms.addAll(
      createKeywords(dynamicString.trim()),
    );
    // reorder the array
    var current = searchedArray[0];
    searchedArray.remove(searchedArray[0]);
    searchedArray.add(current);
  }

  var distinctTerms = finalTerms.toSet().toList();
  return distinctTerms;
}

String toLowerCamelCase(String str) {
  if(str.isEmpty) return str;

  // Split the string by spaces
  List<String> words = str.split(" ");

  // convert the first word to lowercase
  String lowerCamelCase = words[0].toLowerCase();
  if(words.length == 1) return lowerCamelCase;

  // convert the remaining words to capitalized form and concatenate
  for(int i=1; i < words.length; i++){
    String word = words[i];
    if(word.isNotEmpty){
      lowerCamelCase+=word[0].toUpperCase()+word.substring(1).toLowerCase();
    }
  }

  return lowerCamelCase;
}
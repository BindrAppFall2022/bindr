import 'package:books_finder/books_finder.dart';

getInfo(String ISBNum) async {
  final books = await queryBooks(
    ISBNum,
    maxResults: 1,
    printType: PrintType.books,
    orderBy: OrderBy.relevance,
    reschemeImageLinks: true,
  );
  if (books.isEmpty) {
    return null;
  }

  final book = books[0];

  final ISBN = book.info.industryIdentifiers;
  final Name = book.info.title;
  final Author = book.info.authors;
  final Image = book.info.imageLinks['thumbnail'];

  Map<String, Object?> map = {
    "Name": Name,
    "ISBN": ISBN,
    'Author': Author,
    'Image': Image
  };

  return map;
}

/*void main(List<String> args) async {
  print(await getInfo("9780133943030"));
}*/

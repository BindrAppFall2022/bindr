import 'dart:io';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:books_finder/books_finder.dart';

getInfo(String ISBNum) async {
  final books = await queryBooks(
    '$ISBNum',
    maxResults: 1,
    printType: PrintType.books,
    orderBy: OrderBy.relevance,
    reschemeImageLinks: true,
  );

  final book = books[0];

  final ISBN = book.info.industryIdentifiers;
  final Name = book.info.title;
  final Author = book.info.authors;
  final Image = book.info.imageLinks['thumbnail'];

  return {"Name": Name, "ISBN": ISBN, 'Author': Author, 'Image': Image};
}

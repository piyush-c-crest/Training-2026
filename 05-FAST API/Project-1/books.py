from fastapi import FastAPI, Body

app = FastAPI()

books = [
    {'title': 'Title One', 'author': 'Author One', 'category': 'science'},
    {'title': 'Title Two', 'author': 'Author Two', 'category': 'science'},
    {'title': 'Title Three', 'author': 'Author Three', 'category': 'history'},
    {'title': 'Title Four', 'author': 'Author Four', 'category': 'math'},
    {'title': 'Title Five', 'author': 'Author Five', 'category': 'math'},
    {"title": "Title Six", "author": "Author Two", "category": "math"}
]

@app.get('/')
def fun():
    return {'hi':'hello'}

@app.get('/books')
def read_all_books():
    return books 

# path parameter
# @app.get('/books/{param}')  # param is dynamic param
# def fun1(param):
#     return { param : 'temp'}

@app.get('/books/{title}')
def read_book(title : str):
    for book in books:
        if book.get('title').lower() == title.lower():
            return book
        
"""
    query parameters
    query params are request param that have attached after "?" 
    have name value pair
    example 
        /books/?category=math

    fast api directly knows that after books/ whatever added is not path param
    it is query param
"""
@app.get('/books/')
def read_category_by_query(category : str):
    book_in_category = []
    for book in books:
        if book.get('category').casefold() == category.casefold():
            book_in_category.append(book)
    return book_in_category


# both path + query parameter
@app.get('/books/{author}/')
def read_category_author(author:str, category:str, ):
    book_in_category = []
    for book in books:
        if book.get('category').casefold() == category.casefold() and \
                book.get('author').casefold() == author.casefold() :
            book_in_category.append(book)
    return book_in_category


"""
    POST methods -> crate query method
    import Body
    get cant have body Post can have
"""
@app.post('/books/craete_book')
def create_book(new_book = Body()):
    books.append(new_book)
 

"""
    PUT -> update data
    can have body 
    
"""
@app.put('/book/update_book')
def update_book(updated_book=Body()):
    for i in range(len(books)):
        if books[i].get('title').casefold() == updated_book.get('title').casefold():
            books[i] = updated_book


"""
    Delete -> delete data
"""
@app.delete('/books/delete/{title}')
def del_book(title:str):
    for i in range(len(books)):
        if books[i].get('title').casefold() == title.casefold():
            books.pop(i)
            break


"""
        Assignment

Here is your opportunity to keep learning!

1. Create a new API Endpoint that can fetch all books from a specific author using either Path Parameters or Query Parameters.
"""

@app.get('/book/by_author/{author}')
def read_books_by_author_path(author:str):
    author_books = []
    for i in range(len(books)):
        if books[i].get('author').casefold() == author.casefold():
            author_books.append(books[i])
    return author_books

@app.get('/book/')
def read_books_by_author_query(author:str):
    author_books = []
    for i in range(len(books)):
        if books[i].get('author').casefold() == author.casefold():
            author_books.append(books[i])
    return author_books
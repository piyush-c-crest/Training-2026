from typing import Optional
from fastapi import Body, FastAPI, Path, Query, HTTPException
from pydantic import BaseModel, Field
from starlette import status

# Path to validate path
# Query to validate Query

app = FastAPI()

class Book():
    # THESE ARE TYPE HINT ONLY , DO NOT CREATE VARIABLES
    id : int
    title : str
    author : str
    description : str
    rating : int
    publish_date : int

    def __init__(self, id, title, author, description, rating,publish_date):
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.rating = rating
        self.publish_date = publish_date

# Field will make sure all validations
class BookRequest(BaseModel):
    id : Optional[int] = Field(description="No need to pass these", default=None)
    title : str = Field(min_length=3)
    author : str = Field(min_length=3)
    description : str = Field(min_length=2, max_length=100)
    rating : int = Field(gt=0, lt=6)
    publish_date : int = Field(lt=2026)

    model_config = {
        "json_schema_extra" :{
            "example" : {
                "title": "Book Title",
                "author": "Author name",
                "description": "description of book",
                "rating": 5,
                "publish_date" : 2022
            }
        }
    }



books = [
    Book(1, "The Great Gatsby", "F. Scott Fitzgerald", "A novel set in the Roaring Twenties.", 5, 2023),
    Book(2, "To Kill a Mockingbird", "Harper Lee", "A novel about racial injustice in the Deep South.", 5, 2022),
    Book(3, "1984", "George Orwell", "A dystopian novel about totalitarianism.", 4, 2021),
    Book(4, "Pride and Prejudice", "Jane Austen", "A romantic novel about social class and marriage.", 5, 2020),
    Book(5, "The Catcher in the Rye", "J.D. Salinger", "A novel about teenage rebellion and alienation.", 4, 2019),
    Book(6, "Moby Dick", "Herman Melville", "A novel about a whaling voyage.", 4, 2018)
]


@app.get('/books', status_code=status.HTTP_200_OK)
def read_all_books():
    return books

# no validaion
# @app.post('/create_book')
# def creat_book(book=Body()):
#     books.append(book)

@app.post('/create_book', status_code=status.HTTP_201_CREATED)
def creat_book(book : BookRequest):
    new_book = Book(**book.dict())
    books.append(give_book_id(new_book))


def give_book_id(book : Book):
    if(len(books)) > 0:
        book.id = books[-1].id + 1
    else:
        book.id = 1
    return book


@app.get('/books/{id}', status_code=status.HTTP_200_OK)
def read_book_by_id(id:int = Path(gt=0)):
    for i in range(len(books)):
        if books[i].id == id:
            return books[i]
    raise HTTPException(status_code=404, detail="Item not Found")

@app.get('/book/books_by_rating', status_code=status.HTTP_200_OK)
def read_books_by_ratings(rating:int = Query(gt=0, lt=6)):
    books_to_return = []
    for book in books:
        if book.rating == rating:
            books_to_return.append(book)
    return books_to_return 


@app.put('/books/update_book', status_code=status.HTTP_204_NO_CONTENT)
def update_book(book:BookRequest):
    flag = False
    for i in range(len(books)):
        if books[i].id == book.id:
            books[i] = book
            flag = True
    if not flag:
        raise HTTPException(status_code=404, detail="Item not Found") 


@app.delete('/books/delete_book/{id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_book(id:int = Path(gt=0)):
    flag = False
    for i in range(len(books)):
        if books[i].id == id:
            books.pop(i)
            flag = True
            break
    if not flag:
        raise HTTPException(status_code=404, detail="Item not Found") 

@app.get('/books/by_date/', status_code=status.HTTP_200_OK)
def read_books_by_date(pub_date:int = Query(gt=1999, lt = 2026)):
    books_to_return = []
    for book in books:
        if book.publish_date == pub_date:
            books_to_return.append(book)
    return books_to_return








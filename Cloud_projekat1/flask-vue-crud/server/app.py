import uuid
import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Boolean, Column, String

# Konfiguracija
DATABASE_URL = os.environ.get('DATABASE_URL', 'sqlite:///books.db')
# Podrška za Heroku PostgreSQL URL format
if DATABASE_URL and DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

# Inicijalizacija aplikacije
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Enable CORS
CORS(app, resources={r'/*': {'origins': '*'}})

# Model za knjigu
class Book(db.Model):
    __tablename__ = 'books'
    id = Column(String, primary_key=True)
    title = Column(String, nullable=False)
    author = Column(String, nullable=False)
    read = Column(Boolean, default=False)

    def __init__(self, title, author, read):
        self.id = uuid.uuid4().hex
        self.title = title
        self.author = author
        self.read = read

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'author': self.author,
            'read': self.read
        }

# Kreiranje tablica i početni podaci
@app.before_first_request
def create_tables():
    db.create_all()
    
    # Dodajemo početne podatke samo ako je tablica prazna
    if Book.query.count() == 0:
        initial_books = [
            Book('On the Road', 'Jack Kerouac', True),
            Book('Harry Potter and the Philosopher\'s Stone', 'J. K. Rowling', False),
            Book('Green Eggs and Ham', 'Dr. Seuss', True)
        ]
        for book in initial_books:
            db.session.add(book)
        db.session.commit()

# Route za ping
@app.route('/ping', methods=['GET'])
def ping_pong():
    return jsonify('pong, super!')

# Route za knjige
@app.route('/books', methods=['GET', 'POST'])
def all_books():
    response_object = {'status': 'success'}
    
    if request.method == 'POST':
        post_data = request.get_json()
        book = Book(
            title=post_data.get('title'),
            author=post_data.get('author'),
            read=post_data.get('read')
        )
        db.session.add(book)
        db.session.commit()
        response_object['message'] = 'Book added!'
    else:
        books = Book.query.all()
        response_object['books'] = [book.to_dict() for book in books]
    
    return jsonify(response_object)

# Route za jednu knjigu
@app.route('/books/<book_id>', methods=['PUT', 'DELETE'])
def single_book(book_id):
    response_object = {'status': 'success'}
    book = Book.query.filter_by(id=book_id).first()
    
    if not book:
        response_object['status'] = 'error'
        response_object['message'] = 'Book not found!'
        return jsonify(response_object), 404
    
    if request.method == 'PUT':
        post_data = request.get_json()
        book.title = post_data.get('title')
        book.author = post_data.get('author')
        book.read = post_data.get('read')
        db.session.commit()
        response_object['message'] = 'Book updated!'
    
    if request.method == 'DELETE':
        db.session.delete(book)
        db.session.commit()
        response_object['message'] = 'Book removed!'
    
    return jsonify(response_object)

@app.route('/api/health')
def health():
	return jsonify({'status': 'healthy'}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

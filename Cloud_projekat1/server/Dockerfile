FROM python:3.7-slim

WORKDIR /app

RUN pip install --no-cache-dir flask==1.1.2 werkzeug==1.0.1
RUN pip install --no-cache-dir psycopg2-binary Flask-SQLAlchemy

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_ENV=development
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]

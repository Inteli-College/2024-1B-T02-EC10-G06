FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

EXPOSE 8000

COPY . .

# Comando para executar a aplicação usando Gunicorn
CMD ["python", "src/app.py"]
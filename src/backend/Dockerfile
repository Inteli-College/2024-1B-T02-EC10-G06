# 
FROM python:3.9

# 
WORKDIR /code

# 
COPY ./backend/requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 
COPY ./backend/ .

ENV PYTHONPATH "${PYTHONPATH}:/code/"

# 
CMD ["python3", "app.py", "--port", "5001", "--workers=5"]
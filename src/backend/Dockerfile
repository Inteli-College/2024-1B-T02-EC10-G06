# 
FROM python:3.9

# 
WORKDIR /code

# 
COPY ./auth/requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 
COPY ./auth/ .

ENV PYTHONPATH "${PYTHONPATH}:/code/"

# 
CMD ["python3", "app.py", "--port", "5001"]
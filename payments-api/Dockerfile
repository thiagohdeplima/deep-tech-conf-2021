FROM python:3.8-alpine

WORKDIR /srv/app

COPY . .

RUN pip install pika

CMD ["python", "-u", "main.py"]

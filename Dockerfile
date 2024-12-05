FROM rasa/rasa:3.6.20-full

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["rasa", "run", "--enable-api", "--cors", "*"]

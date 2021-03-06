FROM python:3.8

COPY . /root
WORKDIR /root
RUN pip install -r requirements.txt

EXPOSE 8080
CMD [ "python", "server.py" ]

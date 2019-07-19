FROM ubuntu:16.04

LABEL maintainer "Bill Morrisson <billmorrissonjr@gmail.com>"

ENV locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL C
ENV LC_CTYPE en_US.UTF-8



EXPOSE 9000

WORKDIR /paysys-app

RUN apt update -y && apt install -y python-pip python-dev virtualenv
RUN virtualenv venv

COPY requirements.txt /paysys-app

RUN pip install -r requirements.txt

COPY . /paysys-app

RUN python manage.py db init
RUN python manage.py initdb
RUN python manage.py db migrate
RUN python manage.py db upgrade

CMD python run.py
FROM --platform=amd64 python:3.10.9-alpine

WORKDIR /usr/src/app

COPY requirement.txt .
RUN pip install -r requirement.txt

COPY . .

CMD [ "python", "-m", "flask", "run" ]
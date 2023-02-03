from flask import Flask

app = Flask(__name__)


@app.route("/health")
def home():
    return "service is up", 200


@app.route("/ping", methods=["GET", "POST"])
def ping():
    return "pong", 200


if __name__ == "__main__":
    app.run()

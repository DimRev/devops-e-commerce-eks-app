from flask import Flask
from auth.auth_controller import auth_bp

app = Flask(__name__)

@app.route("/healthz")
def healthz():
    return "OK"

app.register_blueprint(auth_bp, url_prefix="/api/v1/auth")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
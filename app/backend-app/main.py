from flask import Flask
from flask_cors import CORS

from auth.auth_controller import auth_bp
from config.config import Config

app = Flask(__name__)
CORS(app)

config = Config()

print(f"Starting {config.APP_NAME} in {config.ENV} mode...")

@app.route("/healthz")
def healthz():
    return "OK"

app.register_blueprint(auth_bp, url_prefix="/api/v1/auth")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

import os
import json

from flask import Flask, send_from_directory, request
from flask_cors import CORS

from auth.auth_controller import auth_bp
from config.config import Config

app = Flask(__name__, static_folder='dist', static_url_path='')
CORS(app)

config = Config()

print(f"Starting {config.APP_NAME} in {config.ENV} mode...")

@app.route("/healthz")
def healthz():
    return "OK"

app.register_blueprint(auth_bp, url_prefix="/api/v1/auth")

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve(path):
    if path and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    else:
        with open(os.path.join(app.static_folder, 'index.html'), 'r') as f:
            html = f.read()
        # api_url = config.API_URL.strip() or f"{request.host_url.rstrip('/')}/api"
        api_url = f"{request.host_url.rstrip('/')}/api"
        env_vars = {
            "ENV": config.ENV,
            "APP_NAME": config.APP_NAME,
            "API_URL": config.API_URL,
            "VERSION": config.VERSION
        }
        injection = f'<script>window.__ENV__ = {json.dumps(env_vars)};</script>'
        html = html.replace('</head>', injection + '</head>')
        return html

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

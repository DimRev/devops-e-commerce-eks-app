from flask import Blueprint, request, jsonify

auth_bp = Blueprint('auth', __name__)
auth_service = AuthService()

@auth_bp.route("/login", methods=["POST"])
def login():
    # You might process the request data here and pass it to login
    result = auth_service.login()
    return jsonify({"message": result})

@auth_bp.route("/logout", methods=["POST"])
def logout():
    result = auth_service.logout()
    return jsonify({"message": result})

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    result = auth_service.register()
    return jsonify({"message": result})

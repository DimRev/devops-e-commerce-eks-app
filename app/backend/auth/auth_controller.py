from flask import Blueprint, request, jsonify
from auth.auth_service import AuthService
from auth.auth_schema import login_request_schema, logout_request_schema, register_request_schema

auth_bp = Blueprint('auth', __name__)
auth_service = AuthService()

@auth_bp.route("/login", methods=["POST"])
def login():

    login_request = None

    try:
        login_request = login_request_schema(request)
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    result = auth_service.login(login_request)
    return jsonify({"message": result}), 200

@auth_bp.route("/logout", methods=["POST"])
def logout():

    logout_request = None

    try:
        logout_request = logout_request_schema(request)
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    result = auth_service.logout(logout_request)

    return jsonify({"message": result}), 200

@auth_bp.route("/register", methods=["POST"])
def register():

    register_request = None
    try:
        register_request = register_request_schema(request)
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    result = auth_service.register(register_request)
    return jsonify({"message": result})

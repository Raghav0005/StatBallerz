import os
import re
from flask import Flask, send_from_directory, jsonify, request


# FLASK_ENV=dev python server.py for live refresh
IS_DEV = os.environ.get("FLASK_ENV") == "dev"

app = Flask(
    __name__,
    static_folder=None if IS_DEV else "./client/dist",
    static_url_path="" if not IS_DEV else None,
)

def parse_sql_shell_output():
    filename = ".results/results.out"
    with open(filename, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    if not lines:
        return []

    # Parse header
    header_line = lines[1]
    columns = [col.strip() for col in header_line.split('|')]

    # Parse data
    results = []
    for line in lines[3:-4]:
        if not line.strip():
            continue  # skip empty lines
        values = [val.strip() for val in line.split('|')]
        row = dict(zip(columns, values))
        results.append(row)
    print(results)

    return results

def load_and_fill_query(filename, replacements):
    with open(f"queries/{filename}", "r") as f:
        query = f.read()
    for placeholder, value in replacements.items():
        query = query.replace(placeholder, value)
    return query

def run_query_from_template(template_file, replacements):
    query = load_and_fill_query(template_file, replacements)
    with open(".tmp.sql", "w") as f:
        f.write(query)
    os.system("./runSqlFile.sh .tmp.sql")
    return parse_sql_shell_output()

@app.route("/")
def home():
    if IS_DEV:
        return "Running in dev mode. Frontend at http://localhost:5173"
    return send_from_directory(app.static_folder, "index.html")

@app.route("/api/test")
def test():
    # os.system("./runSqlFile.sh a1/2.sql")
    results = parse_sql_shell_output()
    print(results)
    # replace with api response after parsing results.out
    return f"{len(results)}"

@app.route("/api/signup", methods=["POST"])
def signup():
    form_data = request.form
    data =  {key: form_data[key] for key in form_data}
    
    check_replacements = {"{{USERNAME}}": data["username"]}
    check_results = run_query_from_template("check_username_taken.sql", check_replacements)
    
    if check_results and check_results[0].get('CNT') != '0':
        print('Username taken')
        return jsonify({"error": "Username already exists"}), 409
    
    replacements = {
        "{{USERNAME}}": data["username"],
        "{{PASSWORD}}": data["password"],
    }
    results = run_query_from_template("signup_template.sql", replacements)
    
    print(data)
    print(results)
    # replace with api response after parsing results.out
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({"message": "Signup successful"}), 201

@app.route("/api/signin")
def signin():
    params = request.args
    data = {key: params[key] for key in params}
    
    replacements = {
        "{{USERNAME}}": data["username"],
        "{{PASSWORD}}": data["password"],
    }
    results = run_query_from_template("signin_template.sql", replacements)
    print("Signin results:", results)
    
    os.system('./runSqlCmd.sh .listUserTable.sql')

    if results[0]['CNT'] == '1':
        return jsonify({"message": "Sign in successful"}), 201
    else:
        return jsonify({"error": "Invalid username or password"}), 401

@app.route("/api/user", methods=["DELETE"])
def delete_user():
    params = request.args
    params_map = {key: params[key] for key in params}
    user_id = params_map.get("username")
    if not user_id:
        return jsonify({"error": "Username parameter is required"}), 400
    replacements = {
        "{{USERNAME}}": user_id
    }
    results = run_query_from_template("delete_user_template.sql", replacements)

    print("Delete user results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({"message": "User deleted successfully"}), 200
    
@app.route("/api/search")
def searchplayer():
    params = request.args
    data = {key: params[key] for key in params}
    player_name = params_map.get("pname")
    if not player_name:
        return jsonify({"error": "Player name is required"}), 400
    replacements = {
        "{{PLAYER NAME}}": data["pname"],
    }
    results = run_query_from_template("search_player_template.sql", replacements)
    
    print("Search results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({
        "message": "Successful Search of Player",
        "results": results
    }), 200

if __name__ == "__main__":
    os.system("./setupSchema.sh")
    os.system("mkdir .results")
    
    # test user signup + delete
    # with app.test_client() as client:
    #     response = client.post(
    #         "/api/signup",
    #         data={"username": "testuser", "password": "password"},
    #         content_type='application/x-www-form-urlencoded'
    #     )
    
    #     os.system('./runSqlCmd.sh .listTables.sql')
    #     results = parse_sql_shell_output()
    #     print("User results:", results)
        
    #     response = client.delete('/api/user?username=testuser')
    #     print(response.json)
        
    #     os.system('./runSqlCmd.sh .listTables.sql')
    #     results = parse_sql_shell_output()
    #     print("User results:", results)
        
    app.run(debug=True)

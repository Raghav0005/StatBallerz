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
    print(lines)

    if not lines:
        return []

    # Find the header line and separator line
    header_line = None
    separator_line = None
    header_index = -1
    
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped and not stripped.startswith('-') and not stripped.startswith('+'):
            if any(c.isalpha() for c in stripped) and 'record(s)' not in stripped:
                header_line = line
                header_index = i
                # Look for the separator line (dashes) right after the header
                if i + 1 < len(lines) and lines[i + 1].strip().startswith('-'):
                    separator_line = lines[i + 1]
                break
    
    if not header_line or not separator_line:
        print("Could not find header or separator line")
        return []

    # parse field widths based on the separator line (dashes)
    dash_groups = []
    current_start = 0
    in_dashes = False
    
    for i, char in enumerate(separator_line):
        if char == '-' and not in_dashes:
            current_start = i
            in_dashes = True
        elif char != '-' and in_dashes:
            # end of current field
            dash_groups.append((current_start, i))
            in_dashes = False
    
    # handle case where line ends with dashes
    if in_dashes:
        dash_groups.append((current_start, len(separator_line)))

    columns = []
    for start, end in dash_groups:
        if start < len(header_line):
            col_name = header_line[start:end].strip()
            if col_name:
                columns.append(col_name)

    print(f"Columns: {columns}")
    print(f"Field positions: {dash_groups}")

    # Parse data rows using fixed-width positions
    results = []
    data_start = header_index + 2  # Skip header and separator line
    
    for line in lines[data_start:]:
        stripped = line.strip()
        
        # Skip empty lines and footer lines
        if (not stripped or 
            stripped.startswith('-') or 
            stripped.startswith('+') or
            'record(s)' in stripped or
            'selected' in stripped):
            continue
        
        # extract using fixed-width positions
        row = {}
        for i, (start, end) in enumerate(dash_groups):
            if i < len(columns):
                if start < len(line):
                    value = line[start:end].strip()
                    row[columns[i]] = value if value else None
                else:
                    row[columns[i]] = None
        
        if row:
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
    username = params_map.get("username")
    if not username:
        return jsonify({"error": "Username parameter is required"}), 400
    replacements = {
        "{{USERNAME}}": username
    }
    results = run_query_from_template("delete_user_template.sql", replacements)

    print("Delete user results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({"message": "User deleted successfully"}), 200

@app.route("/api/password", methods=["POST"])
def update_password():
    params = request.args
    params_map = {key: params[key] for key in params}
    username = params_map.get("username")
    pwd = params_map.get("password")
    if not username:
        return jsonify({"error": "Username parameter is required"}), 400
    if not pwd:
        return jsonify({"error": "Password is required"}), 400
    replacements = {
        "{{USERNAME}}": username,
        "{{PASSWORD}}": pwd,
    }
    results = run_query_from_template("update_user_password_template.sql", replacements)

    print("Updated user password results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({"message": "User password updated successfully"}), 200

@app.route("/api/search")
def searchplayer():
    params = request.args
    params_map = {key: params[key] for key in params}
    player_name = params_map.get("pname")
    if not player_name:
        return jsonify({"error": "Player name is required"}), 400
    replacements = {
        "{{PLAYER NAME}}": player_name,
    }
    results = run_query_from_template("search_player_template.sql", replacements)
    
    print("Search results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({
        "message": "Successful Search of Player",
        "results": results
    }), 200

# games
@app.route("/api/games/stats", methods=["GET"])
def get_games_stats():
    params = request.args
    params_map = {key: params[key] for key in params}
    
    start_date = params_map.get("startDate")
    end_date = params_map.get("endDate")
    stat = params_map.get("stat", "Points")
    if not start_date or not end_date:
        return jsonify({"error": "Start date and end date are required"}), 400
    replacements = {
        "{{START_DATE}}": start_date,
        "{{END_DATE}}": end_date,
        "{{STAT}}": stat,
    }
    results = run_query_from_template("get_games_stats_template.sql", replacements)
    print("Games stats results:", results)
    os.system('./runSqlCmd.sh .listUserTable.sql')
    return jsonify({
        "message": "Games stats retrieved successfully",
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

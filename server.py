import os
import re
from flask import Flask, send_from_directory, jsonify, request

app = Flask(__name__, static_folder="./client/dist", static_url_path="")

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

    return results

@app.route("/")
def home():
    # replace with react index page
    return send_from_directory(app.static_folder, "index.html")

def load_str(filename):
    str_data = ""
    with open(f"queries/{filename}.sql", "r") as f:
        for line in f:
            str_data += line
    return str_data

@app.route("/api/test")
def test():
    # os.system("./runSqlFile.sh a1/2.sql")
    results = parse_sql_shell_output()
    print(results)
    # replace with api response after parsing results.out
    return f"{len(results)}"

@app.route("/api/signup", methods=["POST"])
def test():
    form_data = request.form
    data =  {key: form_data[key] for key in form_data}
    str_data = load_str("signup_template")
    
    line = str_data.split("PLACEHOLDER")
    new_query = line[0] + data["username"] + line[1] + data["password"] + line[2]
    with open(".tmp.sql", "w") as f:
        f.write(new_query)
    os.system("./runSqlFile.sh .tmp.sql")
    results = parse_sql_shell_output()
    print(results)
    # replace with api response after parsing results.out
    return jsonify(results)

@app.route("/api/signin")
def signin():
    params = request.args
    data = {key: params[key] for key in params}
    str_data = load_str("signin_template")

    line = str_data.split("PLACEHOLDER")
    new_query = line[0] + data["username"] + line[1] + data["password"] + line[2]
    with open(".tmp.sql", "w") as f:
        f.write(new_query)
    os.system("./runSqlFile.sh .tmp.sql")
    results = parse_sql_shell_output()
    print(results)
    # replace with api response after parsing results.out
    return jsonify(results)

if __name__ == "__main__":
    os.system("./setupSchema.sh")
    os.system("mkdir .results")
    app.run(debug=True)

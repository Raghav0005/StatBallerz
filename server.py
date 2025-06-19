import os
import re
from flask import Flask

app = Flask(__name__)

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
    return "Hello, Flask!"

@app.route("/api/test")
def test():
    # os.system("./runSqlFile.sh a1/2.sql")
    results = parse_sql_shell_output()
    print(results)
    # replace with api response after parsing results.out
    return f"{len(results)}"

if __name__ == "__main__":
    os.system("./setupSchema.sh")
    os.system("mkdir .results")
    app.run(debug=True)

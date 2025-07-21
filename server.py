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

@app.route("/api/player/search", methods=["GET"])
def search_player():
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

@app.route("/api/team/search", methods=["GET"])
def search_team():
    params = request.args
    params_map = {key: params[key] for key in params}
    team_name = params_map.get("teamname")
    if not team_name:
        return jsonify({"error": "Team name is required"}), 400
    
    # get the teams
    team_replacements = {
        "{{TEAM NAME}}": team_name,
    }
    team_results = run_query_from_template("search_team_template.sql", team_replacements)
    print(team_results)
    # for each team found, fetching the players
    for team in team_results:
        if 'TEAMID' in team:
            player_replacements = {
                "{{TEAM_ID}}": str(team['TEAMID'])
            }
            player_results = run_query_from_template("get_team_players_template.sql", player_replacements)
            team['players'] = player_results
        else:
            team['players'] = []
    
    print("Search results with players:", team_results)
    return jsonify({
        "message": "Successful Search of Team",
        "results": team_results
    }), 200

@app.route("/api/leaderboard", methods=["GET"])
def get_leaderboard():
    try:
        results = run_query_from_template("leaderboard.sql", {})
        return jsonify({
            "message": "Leaderboard retrieved successfully",
            "results": results
        }), 200
    except Exception as e:
        print(f"Error retrieving leaderboard: {str(e)}")
        return jsonify({"error": "Failed to retrieve leaderboard"}), 500

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
    
@app.route("/api/games/teams", methods=["GET"])
def get_game_teams():
    params = request.args
    game_ids = params.get("gameIds", "")
    
    if not game_ids:
        return jsonify({"error": "Game IDs are required"}), 400
    
    game_ids_list = [str(int(id.strip())) for id in game_ids.split(",") if id.strip().isdigit()]
    game_ids_formatted = ",".join(game_ids_list)
    
    if not game_ids_formatted:
        return jsonify({"error": "Valid game IDs are required"}), 400
    
    replacements = {
        "{{GAME_IDS}}": game_ids_formatted,
    }
    
    results = run_query_from_template("get_game_teams_template.sql", replacements)
    print("Game teams results:", results)
    
    return jsonify({
        "message": "Game teams retrieved successfully",
        "results": results  
    }), 200
    
@app.route("/api/special-queries/answered-all-questions")
def answered_all_questions_as_user():
    params = request.args
    params_map = {key: params[key] for key in params}
    username = params_map.get("username")
    if not username:
        return jsonify({"error": "Username parameter is required"}), 400
    
    replacements = {
        "{{USERNAME}}": username,
    }
    results = run_query_from_template("answered_all_questions_as_user.sql", replacements)
    
    print("Special query results:", results)
    return jsonify({
        "message": "Successfully found users who answered all questions as current user",
        "results": results
    }), 200

@app.route("/api/special-queries/answered-all-correct-single-attempt")
def answered_all_correct_single_attempt():
    try:
        results = run_query_from_template("answered_all_correct_single_attempt.sql", {})
        
        print("Answered all correct single attempt results:", results)
        return jsonify({
            "message": "Successfully found users who answered all questions correctly in a single attempt",
            "results": results
        }), 200
    except Exception as e:
        print(f"Error retrieving answered all correct single attempt: {str(e)}")
        return jsonify({"error": "Failed to retrieve results"}), 500
    
@app.route("/api/special-queries/player-stats-intersection", methods=["GET"])
def player_stats_intersection():
    params = request.args
    player1 = params.get("player1")
    stat1 = params.get("stat1")
    player2 = params.get("player2")
    stat2 = params.get("stat2")
    if not all([player1, stat1, player2, stat2]):
        return jsonify({"error": "player1, stat1, player2, and stat2 parameters are required"}), 400
    
    # Validate player names exist in database
    player1_validation = run_query_from_template("validate_player_name_template.sql", {"{{PLAYER_NAME}}": player1})
    player2_validation = run_query_from_template("validate_player_name_template.sql", {"{{PLAYER_NAME}}": player2})
    
    if not player1_validation or player1_validation[0].get('PLAYERCOUNT', '0') == '0':
        return jsonify({"error": f"Player '{player1}' not found in database"}), 404
    
    if not player2_validation or player2_validation[0].get('PLAYERCOUNT', '0') == '0':
        return jsonify({"error": f"Player '{player2}' not found in database"}), 404
    
    replacements = {
        "{{PLAYER1}}": player1,
        "{{STAT1}}": stat1,
        "{{PLAYER2}}": player2,
        "{{STAT2}}": stat2,
    }
    results = run_query_from_template("player_stats_intersection_template.sql", replacements)
    return jsonify({
        "message": "Players matching stats intersection retrieved successfully",
        "results": results
    }), 200
@app.route("/api/question", methods=["POST"])
def add_question():
    data = request.get_json()
    username = data.get("username")
    question_text = data.get("questionText")
    answers = data.get("answers", [])

    # Get UserID
    user_replacements = {"{{USERNAME}}": username}
    user_results = run_query_from_template("get_user_id_template.sql", user_replacements)
    print("User query result:", user_results)
    if not user_results:
        return jsonify({"error": "User not found"}), 404

    author_id = user_results[0].get('USERID')
    if not author_id:
        return jsonify({"error": "Could not retrieve user ID"}), 500

    # Escape single quotes for SQL-safe input
    question_text_escaped = question_text.replace("'", "''")

    # Insert question
    question_replacements = {
        "{{AUTHOR_ID}}": str(author_id),
        "{{QUESTION_TEXT}}": question_text_escaped
    }
    question_insert_result = run_query_from_template("add_question_template.sql", question_replacements)
    print("Insert question result:", question_insert_result)

    # Get inserted QuestionID
    get_question_id_replacements = {
        "{{AUTHOR_ID}}": str(author_id),
        "{{QUESTION_TEXT}}": question_text_escaped
    }
    question_id_results = run_query_from_template("get_latest_question_id_template.sql", get_question_id_replacements)
    print("Get question ID result:", question_id_results)

    if not question_id_results:
        return jsonify({"error": "Failed to retrieve question ID"}), 500

    question_id = question_id_results[0].get('QUESTIONID')
    if not question_id:
        return jsonify({"error": "Could not retrieve question ID"}), 500

    # Insert answers
    for i, answer in enumerate(answers):
        answer_text_escaped = answer["text"].replace("'", "''")
        answer_replacements = {
            "{{QUESTION_ID}}": str(question_id),
            "{{ANSWER_NUMBER}}": str(i + 1),
            "{{RESPONSE_TEXT}}": answer_text_escaped,
            "{{IS_CORRECT}}": "TRUE" if answer.get("isCorrect") else "FALSE"
        }
        result = run_query_from_template("add_answer_template.sql", answer_replacements)
        print(f"Answer insert result for answer {i+1}:", result)

    os.system('./runSqlCmd.sh .listUserTable.sql')
    os.system('./runSqlCmd.sh .listQuestions.sql')

    print("Add question with answers completed successfully")
    return jsonify({
        "message": "Question and answers added successfully",
        "questionId": question_id
    }), 201
    
@app.route("/api/quiz/random", methods=["GET"])
def get_random_quiz():
    try:
        # Get random questions with answers
        questions_data = run_query_from_template("get_random_questions_template.sql", {})
        
        if not questions_data:
            return jsonify({"error": "No questions available"}), 404
            
        # Transform flat data into structured format
        questions_dict = {}
        
        for row in questions_data:
            question_id = row['QUESTIONID']
            
            # Create question entry if it doesn't exist
            if question_id not in questions_dict:
                questions_dict[question_id] = {
                    "questionId": question_id,
                    "questionText": row['QUESTIONTEXT'],
                    "authorId": row['AUTHORID'],
                    "answers": []
                }
            
            # Add answer to the question
            questions_dict[question_id]["answers"].append({
                "answerNumber": row['ANSWERNUMBER'],
                "responseText": row['RESPONSETEXT'],
                "isCorrect": row['ISCORRECT']
            })
        
        # Convert to list and ensure we have exactly 7 questions
        questions_list = list(questions_dict.values())
        
        if len(questions_list) < 7:
            return jsonify({
                "warning": f"Only {len(questions_list)} questions available",
                "questions": questions_list
            }), 200
            
        return jsonify({
            "message": "Random quiz questions retrieved successfully",
            "questionsCount": len(questions_list),
            "questions": questions_list
        }), 200
        
    except Exception as e:
        print(f"Error getting random quiz: {str(e)}")
        return jsonify({"error": "Failed to retrieve quiz questions"}), 500

@app.route("/api/quiz/submit", methods=["POST"])
def submit_quiz_attempt():
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "Request body is required"}), 400
        
        username = data.get("username")
        score = data.get("score")
        attempt_items = data.get("attemptItems", [])
        
        if not username:
            return jsonify({"error": "Username is required"}), 400
        
        if score is None:
            return jsonify({"error": "Score is required"}), 400
        
        # Validate that score is a non-negative integer
        if not isinstance(score, int) or score < 0:
            return jsonify({"error": "Score must be a non-negative integer"}), 400
        
        # First, check if user exists and get their UserID
        user_query_replacements = {"{{USERNAME}}": username}
        user_results = run_query_from_template("get_user_id_template.sql", user_query_replacements)
        
        print(f"User query results: {user_results}")
        
        if not user_results or len(user_results) == 0:
            return jsonify({"error": "User not found"}), 404
        
        user_id = user_results[0]['USERID']  # Get UserID from dictionary
        print(f"Found user_id: {user_id}")
        
        # Insert the quiz attempt - Convert integers to strings for template replacement
        attempt_replacements = {
            "{{USER_ID}}": str(user_id),
            "{{SCORE}}": str(score)
        }
        attempt_results = run_query_from_template("insert_quiz_attempt_template.sql", attempt_replacements)
        print(f"Insert attempt results: {attempt_results}")
        
        # Get the generated AttemptID
        attempt_id_query_replacements = {"{{USER_ID}}": str(user_id)}
        attempt_id_results = run_query_from_template("get_latest_attempt_id_template.sql", attempt_id_query_replacements)
        
        print(f"Attempt ID query results: {attempt_id_results}")
        
        if not attempt_id_results or len(attempt_id_results) == 0:
            return jsonify({"error": "Failed to retrieve attempt ID"}), 500
        
        attempt_id = attempt_id_results[0]['ATTEMPTID']  # Get AttemptID from dictionary
        print(f"Found attempt_id: {attempt_id}")
        
        # Insert quiz attempt items - Convert all integers to strings
        for item in attempt_items:
            question_id = item.get("questionId")
            answer_number = item.get("answerNumber")
            
            if question_id is not None and answer_number is not None:
                item_replacements = {
                    "{{ATTEMPT_ID}}": str(attempt_id),
                    "{{QUESTION_ID}}": str(question_id),
                    "{{ANSWER_NUMBER}}": str(answer_number)
                }
                run_query_from_template("insert_quiz_attempt_item_template.sql", item_replacements)
        
        return jsonify({
            "message": "Quiz attempt submitted successfully",
            "attemptId": attempt_id,
            "score": score
        }), 200
        
    except Exception as e:
        print(f"Error submitting quiz attempt: {e}")
        return jsonify({"error": "Internal server error"}), 500

@app.route("/api/questions/count")
def get_question_count():
    try:
        # Run a query to count total questions in the database
        results = run_query_from_template("count_questions_template.sql", {})
        print("Question count results:", results)
        count = int(results[0]['COUNT']) if results and 'COUNT' in results[0] else 0
        
        return jsonify({"count": count}), 200
    except Exception as e:
        print("Error fetching question count:", str(e))
        return jsonify({"error": "Failed to fetch question count"}), 500
    

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
        
    app.run(debug=True, port=5000)

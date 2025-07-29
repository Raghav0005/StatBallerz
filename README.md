# cs348-project

## Running the Application:

### Step 1: Log in to UW servers
```
ssh linux.student.cs.uwaterloo.ca
```
### Step 2: Clone this repo
```
git clone git@github.com:Raghav0005/StatBallerz.git
```
OR
```
git clone https://github.com/Raghav0005/StatBallerz.git
```
### Step 3: Go into client directory, install dependencies and build
```
cd StatBallerz/client
npm i
npm run build
```

### Step 4: Start a new virtual environment and install flask in it
```
cd ..
python -m venv venv
source venv/bin/activate
pip install flask
```
### Step 5: Start the flask server
```
python server.py
```
### Step 6: To use the app, use port forwarding (automatically done if using vscode) to route port 5000 on the student server to port 5000 on your machine

### Step 7: Visit 127.0.0.1:5000 in your browser

***

## Testing the database for production data

### Step 1: SSH into student server and clone the repo
```
ssh linux.student.cs.uwaterloo.ca
git clone https://github.com/Raghav0005/StatBallerz.git
```
### Step 2: Loading the production database
```
./setupSchema.sh
```
### Step 3: Testing the database
```
./runSqlCmd.sh tests/q1/production/query.sql # run any file you want, based on the folders in tests
```

***

## Testing the database for sample data

### Step 1: SSH into student server and clone the repo
```
ssh linux.student.cs.uwaterloo.ca
git clone https://github.com/Raghav0005/StatBallerz.git
```
### Step 2: Loading the sample database
```
./runSqlFile.sh insert_sample_database.sql
```
### Step 3: Testing the database
```
./runSqlCmd.sh tests/q1/sample/query.sql # run any file you want, based on the folders in tests
```

***

## Current Features -- Milestone 1 + 2 + 3:

As of Milestone 3, our application is fully functioning and implements the necessary 5 basic SQL features as well as 5 advanced SQL features.

Our SQL schema have been appropriately defined and created, and our application successfully leverages the database for both sample and production data. Testing for our SQL is included in the tests folder for both the 5 basic features and 5 advanced features, with instructions on how to execute the tests yourself above.

For clarity, we have also included screenshots demonstrating all the required (and additional) features for the application that have been implemented below:

### Basic Features

Home/Login Page: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 20 17 PM" src="https://github.com/user-attachments/assets/3018aa47-03e0-4ba8-9116-a4ca98acaf03" />

Sign up: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 22 09 PM" src="https://github.com/user-attachments/assets/3bb9ab4b-0d1a-4826-b235-1ea02d69dd2d" />
<img width="500" alt="Screen Shot 2025-06-19 at 3 22 35 PM" src="https://github.com/user-attachments/assets/a538b89b-9d93-4b9c-a716-fb9b89a5f1ed" />

Unsuccessful Login: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 31 PM" src="https://github.com/user-attachments/assets/cacf352a-0da4-4948-b37a-53cab11b42eb" />

Successful Login: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/5598e06d-2798-4acc-bab8-0fac156d912f" />
<img width="500" alt="Screen Shot 2025-06-19 at 3 25 09 PM" src="https://github.com/user-attachments/assets/e0e6dca0-e6c8-4ff8-a0ae-8bd680e6050c" />

Password Change: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/0adfbace-f068-4366-9533-8d0b522ffcf1" />
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/7353e282-8bcc-4b0e-9fc8-9b43582032bb" />

Account Deletion: <br/>
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/60329cc1-d163-4020-96f7-ccf89516f1cf" />
<img width="500" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/2bc0258f-63e1-4128-963e-7b9b8a829978" />

Average of Player Stat For Every Game Between DATE1 and DATE2: <br/>
<img width="876" height="762" alt="Screen Shot 2025-07-29 at 6 10 37 PM" src="https://github.com/user-attachments/assets/87179217-6322-4bf9-9992-02fcc8fa18e9" />

### Advanced Features
Perfect Scorers: <br/>
<img width="857" height="524" alt="Screen Shot 2025-07-29 at 5 56 33 PM" src="https://github.com/user-attachments/assets/e6737e28-fe54-48b1-8b42-6ff2168b7822" />

Answered Same Quiz Questions: <br/>
<img width="857" height="568" alt="Screen Shot 2025-07-29 at 6 03 04 PM" src="https://github.com/user-attachments/assets/aeed3a82-52ab-4379-818f-dc6452dc1df1" />

Player Intersection: <br/>
<img width="640" height="726" alt="Screen Shot 2025-07-29 at 6 04 50 PM" src="https://github.com/user-attachments/assets/62909bf7-9a7b-44d8-953a-f7392b981374" />

Player Statistics View: <br/>
<img width="850" height="559" alt="Screen Shot 2025-07-29 at 6 07 26 PM" src="https://github.com/user-attachments/assets/427e0b9d-8eae-4647-9a86-585cbedc0891" />

Indexes: <br/>
** Used for fast retrieval player names, game dates, team names and attempt scores ** <br/>
Example of team name lookup with indices: <br/>
<img width="847" height="206" alt="Screen Shot 2025-07-29 at 6 12 48 PM" src="https://github.com/user-attachments/assets/7f6d124f-1a60-4eaf-b2e3-6558c4b5a88d" />


### Additional Features
Add Player Question: <br/>
<img width="507" height="630" alt="Screen Shot 2025-07-29 at 6 17 17 PM" src="https://github.com/user-attachments/assets/ce047dd8-c001-4f6d-9d93-2cfab5666a6c" />

Add Team Question: <br/>
<img width="504" height="631" alt="Screen Shot 2025-07-29 at 6 18 34 PM" src="https://github.com/user-attachments/assets/62a39008-cd13-43bb-b480-480fb778034e" />

Quiz feature: <br/>
<img width="826" height="766" alt="Screen Shot 2025-07-29 at 6 19 54 PM" src="https://github.com/user-attachments/assets/dcbe8e3b-7fb7-4731-8cc1-5bc8e92c0cc4" /> <br/>
<img width="632" height="750" alt="Screen Shot 2025-07-29 at 6 20 22 PM" src="https://github.com/user-attachments/assets/d23f036a-fa1c-49f6-82c5-192bb6089818" />

Leaderboard View for Quiz Attempts: <br/>
<img width="541" height="477" alt="Screen Shot 2025-07-29 at 6 20 36 PM" src="https://github.com/user-attachments/assets/4e92ebb1-48da-42a3-9925-e11122c6e6a9" />


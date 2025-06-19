# cs348-project

## Current Features -- Milestone 1:

The current iteration of the project as of Milestone 1 has a successfully set up frontend (React + Javascript + Vite) and backend (Flask). We have successfully integrated 1-2 simple features/functionalities, being the login and the signup, which will serve as a starting point for completing the rest of our project (Rubric C5)! 

Our SQL schema's have been appropriately defined and created, and the frontend can successfully access our database. The login and signup pages are done and have been created, fully functioning with our database. Once a user signs up and logs into their newly created account, a preliminary search/home pages is visible that can be seen on successfully login.

* We also have sample test data and test queries for our 4 basic features for Milestone 1 (in the test folder)

## Steps To Run:

## Step 1: Log in to UW servers and source DB2 scripts
```
ssh linux.student.cs.uwaterloo.ca
```
## Step 2: Clone this repo
```
git clone git@github.com:Raghav0005/StatBallerz.git
```
## Step 3: Go into client directory, install dependencies and build
```
cd StatBallerz/client
npm i
npm run build
```

## Step 4: Start a new virtual environment and install flask in it
```
cd ..
python -m venv venv
source venv/bin/activate
pip install flask
```
## Step 5: Start the flask server
```
python server.py
```
## Step 6: To use the app, use port forwarding (automatically done if using vscode) to route port 5000 on the student server to port 5000 on your machine

## Step 7: Visit 127.0.0.1:5000 in your browser

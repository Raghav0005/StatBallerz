# cs348-project

## Current Features -- Milestone 1:

The current iteration of the project as of Milestone 1 has a successfully set up frontend (React + Javascript + Vite) and backend (Flask). We have successfully integrated 1-2 simple features/functionalities, being the login and the signup, which will serve as a starting point for completing the rest of our project (Rubric C5)! 

Our SQL schema's have been appropriately defined and created, and the frontend can successfully access our database. The login and signup pages are done and have been created, fully functioning with our database. Once a user signs up and logs into their newly created account, a preliminary search/home pages is visible that can be seen on successfully login.

Home/Login Page:
<img width="1512" alt="Screen Shot 2025-06-19 at 3 20 17 PM" src="https://github.com/user-attachments/assets/3018aa47-03e0-4ba8-9116-a4ca98acaf03" />

Sign up:
<img width="1512" alt="Screen Shot 2025-06-19 at 3 22 09 PM" src="https://github.com/user-attachments/assets/3bb9ab4b-0d1a-4826-b235-1ea02d69dd2d" />
<img width="1512" alt="Screen Shot 2025-06-19 at 3 22 35 PM" src="https://github.com/user-attachments/assets/a538b89b-9d93-4b9c-a716-fb9b89a5f1ed" />

Unsuccessful Login:
<img width="1512" alt="Screen Shot 2025-06-19 at 3 24 31 PM" src="https://github.com/user-attachments/assets/cacf352a-0da4-4948-b37a-53cab11b42eb" />
<img width="1512" alt="Screen Shot 2025-06-19 at 3 24 54 PM" src="https://github.com/user-attachments/assets/5598e06d-2798-4acc-bab8-0fac156d912f" />
<img width="1512" alt="Screen Shot 2025-06-19 at 3 25 09 PM" src="https://github.com/user-attachments/assets/e0e6dca0-e6c8-4ff8-a0ae-8bd680e6050c" />



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

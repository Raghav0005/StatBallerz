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

## Testing the database for sample data

### Step 1: SSH into student server and clone the repo
```
ssh linux.student.cs.uwaterloo.ca
git clone https://github.com/Raghav0005/StatBallerz.git
```
### Step 2: Loading the database
```
./setupSchema.sh
```
### Step 3: Testing the database
```
./runSqlCmd.sh tests/q1/query.sql # run any file you want, based on the folders in tests
```

***

## Current Features -- Milestone 1 + 2:

The current iteration of the project as of Milestone 2 has a successfully set up frontend (React + Javascript + Vite) and backend (Flask). We have successfully integrated 3-4 simple features/functionalities for the project! 

Our SQL schema's have been appropriately defined and created, and our application successfully leverages the database for both sample and production data. The user logic has been implemented as shown below (4 basic features), as well as an additional feature of allowing the user to search for players in the searchbar once logged in. Advanced queries and associated logic will be further implemented on top of these basic application features in Milestone 3.)

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

Search for Player (Additional Feature):
<img width="1512" alt="Screen Shot 2025-07-08 at 9 32 31 PM" src="https://github.com/user-attachments/assets/91b3b0f0-1c6c-45da-9836-4aee7245d95a" />

* Sample/production test data and test queries for our 5 basic features for Milestone 2 is in the 'test' folder

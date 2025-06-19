# cs348-project

## Step 1: Log in to UW servers and source DB2 scripts
```
ssh linux.student.cs.uwaterloo.ca <br>
```
## Step 2: Clone this repo
```
git clone git@github.com:Raghav0005/StatBallerz.git
```
## Step 3: Go into client directory, install dependencies and build
```
cd StatBallerz/client <br>
npm i <br>
npm run build <br>
```

## Step 4: Start a new virtual environment and install flask in it
```
cd .. <br>
python -m venv venv <br>
source venv/bin/activate <br>
pip install flask <br>
```
## Step 5: Start the flask server
```
python server.py <br>
```
## Step 6: To use the app, use port forwarding (presumably using vscode) to route port 5000 on the student server to port 5000 on your machine

## Step 7: Visit 127.0.0.1:5000 in your browser

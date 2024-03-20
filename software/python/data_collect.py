from firebase_admin import credentials, initialize_app, db
import csv

# Set the credentials to access Firebase
cred = credentials.Certificate('C:/Users/ADMIN/Documents/airguard\python_data_collect/air-guard-127e8-firebase-adminsdk-zcqup-d60a4b4cd7.json')
# Initialize the app with a custom database URL
options = {
    'databaseURL': 'https://air-guard-127e8-default-rtdb.asia-southeast1.firebasedatabase.app/'
}
initialize_app(cred, options)

# Get a reference to the database service
ref = db.reference("/devices/c5M2L90UO6SYQcTXuXDFZloNbgN2/reading/")

# Define the CSV file name and header row
csv_file = 'hydropod_data.csv'
header = ['temp', 'humi', 'condition']

conditionIn = False
# Listen to the database changes
def on_data_change(event):
    print("New data")
    global conditionIn
    data = event.data
    if(data.get('condition')!=None):
        conditionIn = data.get('condition')
    row = [data.get('temp'), data.get('humi'), conditionIn]
    if data.get('temp') != 0: # and data.get('ec') != 0: #and list(data.values()) != last_row:
        with open(csv_file, mode='a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(row)
        print('Data saved to CSV:', row)
ref.listen(on_data_change)
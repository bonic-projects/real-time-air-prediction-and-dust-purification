import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
import numpy as np

# Load data without header
data = pd.read_csv('data.csv', header=None, names=['temp', 'humi', 'dust', 'mq135', 'mq4', 'mq7', 'condition'])

# Encode categorical variable 'status'
label_encoder = LabelEncoder()
data['condition'] = label_encoder.fit_transform(data['condition'])

# Split data into features and target variable
X = data.drop('condition', axis=1)
y = data['condition']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Initialize and train the model
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Make predictions and probabilities
predictions = model.predict(X_test)
# probabilities = model.predict_proba(X_test)

# Evaluate the model
print(classification_report(y_test, predictions))

# Calculate accuracy
accuracy = accuracy_score(y_test, predictions)
print("Accuracy:", accuracy)

# Example of using the model to predict
new_data = pd.DataFrame({'temp': [36], 'humi': [55], 'dust': [0.41465], 'mq135': [0], 'mq4': [0], 'mq7': [0]})
predicted_status = label_encoder.inverse_transform(model.predict(new_data))
print("Predicted status:", predicted_status)

predicted_probabilities = model.predict_proba(new_data)
for status, prob in zip(label_encoder.classes_, predicted_probabilities[0]):
    print(f"{status}: {prob}")
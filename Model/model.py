import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score, LeaveOneOut
from sklearn.preprocessing import LabelEncoder
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from imblearn.over_sampling import RandomOverSampler
import pickle
import seaborn as sns
import matplotlib.pyplot as plt

# Section 1: Load and Explore the Dataset
data = pd.read_csv('enhanced_track_suitability_dataset.csv')  # Load the enhanced dataset

# Basic data overview
print("Data Overview:\n", data.head())
print("\nData Description:\n", data.describe())
print("\nData Info:\n", data.info())

# Section 2: Check for Missing Values
missing_values = data.isnull().sum()
print("\nMissing Values:\n", missing_values)

# Section 3: Data Preprocessing
# Separate features (Q1 to Q30) and the target
X = data.drop(columns=['Target'])
y = data['Target']

# Encode the target variable
label_encoder = LabelEncoder()
y = label_encoder.fit_transform(y)

# Save the label classes for interpretation later
label_classes = label_encoder.classes_.astype(str)  # Convert classes to strings

# Balance the dataset using Random OverSampling
ros = RandomOverSampler(random_state=42)
X_balanced, y_balanced = ros.fit_resample(X, y)

# Section 4: Model Initialization
xgb_model = XGBClassifier(random_state=42, n_estimators=200, max_depth=6, learning_rate=0.1, eval_metric='mlogloss')

# Section 5: Train-Test Split for Monitoring
X_train, X_val, y_train, y_val = train_test_split(X_balanced, y_balanced, test_size=0.2, random_state=42)

# Section 6: Training the Model with Evaluation Monitoring
eval_set = [(X_train, y_train), (X_val, y_val)]
xgb_model.fit(X_train, y_train, eval_set=eval_set, verbose=True)

# Save the trained model, label encoder, and feature names to a file
with open('track_xgb_model.pkl', 'wb') as model_file:
    pickle.dump(xgb_model, model_file)

with open('track_label_encoder.pkl', 'wb') as encoder_file:
    pickle.dump(label_encoder, encoder_file)

with open('track_feature_names.pkl', 'wb') as feature_file:
    pickle.dump(X.columns.tolist(), feature_file)

# Section 7: Analyze Feature Importance
feature_importances = xgb_model.feature_importances_
sorted_indices = feature_importances.argsort()[::-1]

plt.figure(figsize=(10, 7))
plt.barh(X.columns[sorted_indices], feature_importances[sorted_indices])
plt.xlabel('Importance')
plt.ylabel('Feature')
plt.title('Feature Importances')
plt.show()

# Section 8: Test the Model on Known Inputs
test_inputs = {

    "bio": [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0]

}

def predict_track(test_input):
    df = pd.DataFrame([test_input], columns=X.columns)  # Ensure the DataFrame uses the correct feature names
    prediction = xgb_model.predict(df)
    predicted_track = label_encoder.inverse_transform(prediction)
    return predicted_track[0]

for track, input_data in test_inputs.items():
    predicted_track = predict_track(input_data)
    print(f"Expected Track: {track}, Predicted Track: {predicted_track}")

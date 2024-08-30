from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import pickle

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load your pre-trained model
with open('track_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

# Load the label encoder
with open('track_label_encoder.pkl', 'rb') as encoder_file:
    label_encoder = pickle.load(encoder_file)

# Load the feature names
with open('track_feature_names.pkl', 'rb') as feature_file:
    feature_names = pickle.load(feature_file)

# Map the numerical predictions to track names directly using the classes_ attribute
track_map = {index: label for index, label in enumerate(label_encoder.classes_)}

@app.route('/predict', methods=['POST'])
def predict():
    # Expecting JSON input with a key 'answers'
    data = request.json

    # Ensure the 'answers' key exists and has the correct format
    if 'answers' not in data or not isinstance(data['answers'], list):
        return jsonify({"error": "Invalid input format. 'answers' should be a list."}), 400

    # Convert answers to a DataFrame with the correct feature names
    try:
        df = pd.DataFrame([data['answers']], columns=feature_names)

        # Print the received data
        print("Received DataFrame:")
        print(df)

        # Predict the track using the loaded model
        prediction = model.predict(df)
        predicted_class = int(prediction[0])  # Convert int64 to Python int

        # Print the prediction result
        print("Predicted Class:")
        print(predicted_class)

        # Get the track name from the prediction
        track_name = track_map.get(predicted_class, "Unknown Track")

        return jsonify({"track": track_name})

    except Exception as e:
        # Print the exception for debugging
        print("Error during prediction:")
        print(str(e))
        return jsonify({"error": str(e)}), 500


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "OK"}), 200


if __name__ == '__main__':
    app.run(debug=True)

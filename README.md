# 🎓 Track Selection Quiz App

Welcome to the **Track Selection Quiz App**! This app is designed to help users discover the educational or career track that best suits their interests and skills by answering a series of tailored questions. Whether you're passionate about **Bioinformatics** 🧬, **Cybersecurity** 🛡️, or **Artificial Intelligence** 🤖, this app will guide you to your ideal path!

## 📜 Overview

This project is a comprehensive solution that combines a sleek Flutter-based interface with a powerful machine learning model. The app presents a questionnaire that, upon completion, provides users with a recommendation for their best-suited track, along with useful tips and resources to help them succeed.

### 🛠️ Features

- **Interactive Questionnaire**: Users can answer 30 questions that help determine their suitability for different tracks.
- **Real-time Feedback**: Users can track their progress and see which questions they've answered.
- **Personalized Track Recommendation**: After completing the questionnaire, users receive a recommendation tailored to their answers.
- **Helpful Tips**: The app offers tips and resources based on the recommended track to support users in their learning journey.
- **Responsive and Intuitive UI**: The app features a clean, user-friendly interface built with Flutter.

### 🗂️ Project Structure

The repository is organized into two main folders:

1. **`interface/`**: Contains the Flutter code for the app's user interface.
   - **Screens**: Different screens, such as the questionnaire screen, result screen, and track selection screen.
   - **Widgets**: Reusable UI components like buttons, cards, and navigation elements.
   - **Assets**: Images, icons, and other static resources.

2. **`model/`**: Contains the machine learning model and related code.
   - **Model Training**: Python scripts for data preprocessing, model training, and evaluation.
   - **Flask Server**: A Flask server that serves the trained model and handles predictions.
   - **Data**: The dataset used for training, including scripts for data generation and augmentation.

### 🧠 About the Model

The core of the recommendation system is powered by a **machine learning model** built using the XGBoost algorithm. Here's a deeper dive into the model:

- **Algorithm**: The model leverages **XGBoost (Extreme Gradient Boosting)**, known for its efficiency and accuracy in handling structured data. This choice was made because XGBoost is particularly good at capturing complex patterns in the data, making it ideal for predicting which track best suits a user's responses.
  
- **Training Process**: 
  - The model was trained on a carefully crafted dataset with responses categorized into three tracks: **Bioinformatics**, **Cybersecurity**, and **AI/Data Science**.
  - The dataset was balanced using **Random OverSampling** to ensure that the model isn't biased towards any particular track.
  - During training, the model's performance was monitored using cross-validation and a validation set to prevent overfitting and ensure generalization to new data.

- **Evaluation**:
  - The model was evaluated based on its accuracy and ability to correctly classify users into the appropriate track. Feature importance was also analyzed to understand which questions (features) most influence the model's decisions.

- **Deployment**:
  - The trained model is deployed via a **Flask server** that interacts with the Flutter app. When a user completes the questionnaire, their responses are sent to the server, which then returns a prediction.

### 🚀 Getting Started (continued)

3. **Run the Flask server**:
   - Navigate to the `model/` folder where the Flask app is located.
   - Run the server to serve the machine learning model:
     ```bash
     python app.py
     ```
   - The server should now be running locally, and it will handle incoming requests from the Flutter app.

4. **Run the Flutter app**:
   - Navigate to the `interface/` folder where the Flutter project is located.
   - Install the required Flutter dependencies:
     ```bash
     flutter pub get
     ```
   - Start the Flutter application:
     ```bash
     flutter run
     ```
   - The app should now be running on your connected device or emulator, ready for you to take the quiz and receive track recommendations.

5. **Test the Application**:
   - Open the app and start the quiz by selecting "Start Your Track Test."
   - Answer the questions, and upon completion, the app will send your responses to the Flask server.
   - The server processes the data and returns a recommendation, which is then displayed in the app along with useful tips and resources.

### 🧠 About the Model (continued)

- **Feature Importance**:
  - After training, the model's feature importance was analyzed to understand which questions had the most influence on the track recommendations. This helps in interpreting the model's decisions and ensuring transparency.

- **Handling Imbalanced Data**:
  - To address any potential imbalance in the dataset, **Random OverSampling** was used. This technique helps in balancing the dataset by oversampling the minority class, ensuring that the model does not favor any particular track disproportionately.

### 🎉 Acknowledgments

- Thanks to the contributors and users who tested the app.
- Special thanks to the communities of Flutter and machine learning for providing valuable tools and resources.

---

If you encounter any issues or have any questions, feel free to open an issue in the repository. Happy coding! 🎉

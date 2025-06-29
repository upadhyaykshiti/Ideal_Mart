# Ideal Mart Full Stack Assignment

## 🔧 Tech Stack
- Flutter (mobile app)
- FastAPI + MongoDB Atlas (backend)
- React.js (admin dashboard)
- AWS S3 / MongoDB Atlas (hosting & DB)

## 📱 Features
- User registration and login
- Add/view/delete shopping items (predefined & custom)
- Reminders and notifications
- React dashboard for admin

## 🚀 Deployment
- MongoDB hosted on Atlas
- (Optional) Backend deployed to AWS EC2 or Render

## 🧪 Setup Instructions
### Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload

### Mobile
```bash
cd mobile
flutter pub get
flutter run

### Dashboard
```bash
cd dashboard
npm install
npm start

## 📱 iOS Setup Instructions

To run the Flutter app on iOS:

1. Open the `mobile/` directory in terminal
2. Run:
   ```bash
   flutter pub get
   flutter run


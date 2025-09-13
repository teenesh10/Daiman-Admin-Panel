# Environment Setup Guide

## 🔧 Setting Up Environment Variables

This project uses environment variables to securely manage sensitive configuration data.

### 📋 Quick Setup

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file** with your actual values:
   ```bash
   # Firebase Configuration
   FIREBASE_API_KEY=your_actual_firebase_api_key
   FIREBASE_PROJECT_ID=your_actual_project_id
   FIREBASE_MESSAGING_SENDER_ID=your_actual_sender_id
   FIREBASE_APP_ID=your_actual_app_id
   FIREBASE_FUNCTIONS_URL=your_actual_functions_url

   # Email Configuration
   GMAIL_EMAIL=your_gmail_email@gmail.com
   GMAIL_PASSWORD=your_gmail_app_password

   # Environment
   ENVIRONMENT=development
   ```

3. **Build with environment variables:**
   ```bash
   # Development
   flutter build web --dart-define-from-file=.env

   # Production
   flutter build web --release --dart-define-from-file=.env
   ```

### 🔒 Security Notes

- ✅ **Never commit** `.env` files to version control
- ✅ **Use different values** for development and production
- ✅ **Rotate credentials** regularly
- ✅ **Use app passwords** for Gmail (not your regular password)

### 🚀 Deployment

For production deployment, set environment variables in your hosting platform:

#### Firebase Hosting
```bash
firebase functions:config:set app.gmail_email="your_email@gmail.com"
firebase functions:config:set app.gmail_password="your_app_password"
```

#### Netlify
Set in Site Settings > Environment Variables

#### Vercel
Set in Project Settings > Environment Variables

### 📚 More Information

- [Flutter Environment Variables](https://docs.flutter.dev/deployment/web#environment-variables)
- [Firebase Configuration](https://firebase.google.com/docs/web/setup)
- [Gmail App Passwords](https://support.google.com/accounts/answer/185833)

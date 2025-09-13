# Deployment Guide for Daiman Admin Panel

## Pre-Deployment Checklist

### 1. Security Configuration ✅
- [x] Firebase credentials moved to environment variables
- [x] Hardcoded URLs secured
- [x] Development-only features hidden in production
- [x] Git ignore updated for sensitive files

### 2. Environment Setup

#### For Development:
```bash
# No additional setup required
flutter run -d chrome
```

#### For Production:
```bash
# Set environment variables
export FIREBASE_API_KEY="your_actual_api_key"
export FIREBASE_PROJECT_ID="your_actual_project_id"
export FIREBASE_MESSAGING_SENDER_ID="your_actual_sender_id"
export FIREBASE_APP_ID="your_actual_app_id"
export FIREBASE_FUNCTIONS_URL="your_actual_functions_url"
export ENVIRONMENT="production"
```

## Build Commands

### Development Build
```bash
npm run build:dev
# or
flutter build web --dart-define=ENVIRONMENT=development
```

### Production Build
```bash
npm run build:prod
# or
flutter build web --release --dart-define=ENVIRONMENT=production
```

## Firebase Functions Deployment

### 1. Configure Secrets
```bash
# Set Gmail credentials for email functionality
firebase functions:secrets:set GMAIL_EMAIL
firebase functions:secrets:set GMAIL_PASSWORD
```

### 2. Deploy Functions
```bash
npm run deploy:functions
# or
cd functions && npm install && firebase deploy --only functions
```

## Web Hosting Deployment

### 1. Build for Production
```bash
npm run build:prod
```

### 2. Deploy to Firebase Hosting
```bash
npm run deploy:hosting
# or
firebase deploy --only hosting
```

### 3. Deploy Everything
```bash
npm run deploy:all
```

## Portfolio Deployment Options

### Option 1: Firebase Hosting (Recommended)
1. Build the project: `npm run build:prod`
2. Deploy: `firebase deploy --only hosting`
3. Your app will be available at: `https://your-project-id.web.app`

### Option 2: GitHub Pages
1. Build the project: `npm run build:prod`
2. Copy `build/web` contents to your GitHub Pages repository
3. Push to deploy

### Option 3: Netlify
1. Build the project: `npm run build:prod`
2. Drag and drop `build/web` folder to Netlify
3. Configure environment variables in Netlify dashboard

### Option 4: Vercel
1. Connect your GitHub repository to Vercel
2. Set build command: `flutter build web --release`
3. Set output directory: `build/web`
4. Configure environment variables in Vercel dashboard

## Environment Variables for Different Platforms

### Firebase Hosting
Set in Firebase Console > Project Settings > General > Your apps

### Netlify
Set in Site Settings > Environment Variables

### Vercel
Set in Project Settings > Environment Variables

### GitHub Pages
Use GitHub Secrets for CI/CD or set in your build process

## Security Considerations

1. **Never commit** environment files to version control
2. **Use strong passwords** for Gmail app passwords
3. **Rotate credentials** regularly
4. **Monitor** Firebase Functions logs
5. **Enable** Firebase Security Rules
6. **Use** HTTPS only in production

## Testing After Deployment

1. **Authentication**: Test login functionality
2. **Email**: Test query response emails
3. **Database**: Test CRUD operations
4. **UI**: Verify all features work correctly
5. **Security**: Ensure sensitive data is not exposed

## Troubleshooting

### Common Issues:
1. **Build fails**: Check Flutter and Dart versions
2. **Firebase errors**: Verify environment variables
3. **Email not sending**: Check Gmail app password
4. **CORS errors**: Verify Firebase Functions configuration

### Debug Mode:
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=development
```

## Support

For deployment issues, refer to:
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)
- [Firebase Functions](https://firebase.google.com/docs/functions)

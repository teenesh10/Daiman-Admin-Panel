# Security Configuration for Daiman Admin Panel

## Overview
This document outlines the security measures implemented to protect sensitive data in the Daiman Admin Panel project.

## Environment Variables

### Required Environment Variables
For production deployment, set the following environment variables:

```bash
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id_here
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id_here
FIREBASE_APP_ID=your_firebase_app_id_here

# Firebase Functions URL
FIREBASE_FUNCTIONS_URL=your_firebase_functions_url_here

# Email Configuration (for Firebase Functions)
GMAIL_EMAIL=your_gmail_email_here
GMAIL_PASSWORD=your_gmail_app_password_here

# Environment
ENVIRONMENT=production
```

### Development vs Production
- **Development**: Uses default values for testing
- **Production**: Requires environment variables to be set

## Security Features Implemented

### 1. Firebase Configuration
- Moved hardcoded Firebase credentials to environment variables
- Added configuration service (`lib/config/app_config.dart`)
- Sensitive data is masked in production logs

### 2. Firebase Functions
- Email sending function uses Firebase secrets for Gmail credentials
- Functions are protected with Firebase Authentication
- CORS is properly configured

### 3. URL Security
- Stripe dashboard link only available in development mode
- Firebase Functions URL is configurable
- No hardcoded sensitive URLs in production

### 4. Git Security
- Updated `.gitignore` to exclude sensitive files
- Environment files are not tracked in version control
- Firebase configuration files are excluded

## Deployment Instructions

### For Portfolio/Production Deployment:

1. **Set Environment Variables**:
   ```bash
   export FIREBASE_API_KEY="your_actual_api_key"
   export FIREBASE_PROJECT_ID="your_actual_project_id"
   export FIREBASE_MESSAGING_SENDER_ID="your_actual_sender_id"
   export FIREBASE_APP_ID="your_actual_app_id"
   export FIREBASE_FUNCTIONS_URL="your_actual_functions_url"
   export ENVIRONMENT="production"
   ```

2. **Configure Firebase Functions Secrets**:
   ```bash
   firebase functions:secrets:set GMAIL_EMAIL
   firebase functions:secrets:set GMAIL_PASSWORD
   ```

3. **Build for Production**:
   ```bash
   flutter build web --release
   ```

### For Development:
- No additional setup required
- Uses default development values
- Stripe dashboard is accessible for testing

## Security Checklist

- [x] Firebase credentials moved to environment variables
- [x] Firebase Functions secrets configured
- [x] Hardcoded URLs removed or secured
- [x] Development-only features hidden in production
- [x] Git ignore updated for sensitive files
- [x] Configuration service implemented
- [x] Production logging secured

## Important Notes

1. **Never commit** `.env` files or Firebase configuration files
2. **Always use** environment variables in production
3. **Test thoroughly** after security changes
4. **Rotate credentials** regularly
5. **Monitor** Firebase Functions logs for security issues

## Support

For security-related questions or issues, please refer to the Firebase documentation or contact the development team.

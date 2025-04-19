# Health Tracker API Server

This is the backend server for the Health Tracker application, which utilizes the FatSecret API for food and recipe data.

## Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Create a `.env` file in the root directory with the following variables:
   ```
   PORT=3000
   FATSECRET_CLIENT_ID=your_client_id
   FATSECRET_CLIENT_SECRET=your_client_secret
   ```

3. Run the server:
   ```
   npm start
   ```

   Or for development with auto-reload:
   ```
   npm run dev
   ```

## API Documentation

API documentation is available at `/api-docs` when the server is running.

## Environment Check

To verify that your environment is correctly set up and the FatSecret API is accessible, run:

```
npm run check-env
```

This will:
- Verify environment variables are set
- Test authentication with FatSecret
- Test API access

## Troubleshooting

### IP Restriction Error

If you see a message like this:
```
Invalid IP address detected: 'xxx.xxx.xxx.xxx'
```

This means your FatSecret API key is restricted to specific IP addresses, and your current IP is not on the allowed list.

**Solution:**

1. Log in to your [FatSecret Developer account](https://platform.fatsecret.com/api/)
2. Navigate to your application settings
3. Add your current IP address to the list of authorized IPs
4. Or contact FatSecret support to remove IP restrictions from your account

### JWT Token Issues

If you're having issues with JWT authentication, ensure:
- Your client ID and secret are correct
- The requested scope is valid (use "basic" for most API calls)
- Your account has sufficient permissions

## API Routes

- Foods:
  - GET `/api/v1/foods/search?query=apple` - Search for foods
  - GET `/api/v1/foods/categories` - Get food categories
  - POST `/api/v1/foods/image_recognition` - Recognize food from image

- Recipes:
  - GET `/api/v1/recipes/search?query=chicken` - Search for recipes 
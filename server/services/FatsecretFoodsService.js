// Function to get access token
async function getAccessToken() {
    try {
        const tokenUrl = 'https://oauth.fatsecret.com/connect/token';
        const credentials = Buffer.from(`${process.env.FATSECRET_CLIENT_ID}:${process.env.FATSECRET_CLIENT_SECRET}`).toString('base64');

        const response = await axios.post(tokenUrl,
            'grant_type=client_credentials&scope=premier', // Added premier scope
            {
                headers: {
                    'Authorization': `Basic ${credentials}`,
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }
        );

        return response.data.access_token;
    } catch (error) {
        console.error('[getAccessToken] Error getting access token:', error.response && error.response.data ? error.response.data : error.message);
        throw error;
    }
}

// Get all food categories
async function getFoodCategories() {
    try {
        const token = await getAccessToken();
        const params = new URLSearchParams({
            method: 'food_categories.get.v2', // Updated to v2
            format: 'json'
        });

        const response = await axios.post(
            'https://platform.fatsecret.com/rest/server.api',
            params, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }
        );

        return response.data;
    } catch (error) {
        console.error('[getFoodCategories] Error getting food categories:', error.response && error.response.data ? error.response.data : error.message);
        throw error;
    }
}

module.exports = {
    getAccessToken,
    getFoodCategories
};
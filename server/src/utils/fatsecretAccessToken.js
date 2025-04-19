import axios from "axios";
import qs from "qs";

async function getAccessToken(scope = "basic") {
    const FATSECRET_CLIENT_ID = process.env.FATSECRET_CLIENT_ID;
    const FATSECRET_CLIENT_SECRET = process.env.FATSECRET_CLIENT_SECRET;
    const TOKEN_URL = "https://oauth.fatsecret.com/connect/token";

    try {
        console.log("[getAccessToken] Attempting to get access token with scope:", scope);
        console.log("[getAccessToken] Using client ID:", FATSECRET_CLIENT_ID);

        if (!FATSECRET_CLIENT_ID || !FATSECRET_CLIENT_SECRET) {
            console.error("[getAccessToken] Missing API credentials in environment variables");
            throw new Error("Missing API credentials");
        }

        const response = await axios.post(
            TOKEN_URL,
            qs.stringify({
                grant_type: "client_credentials",
                scope: scope
            }), {
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                auth: {
                    username: FATSECRET_CLIENT_ID,
                    password: FATSECRET_CLIENT_SECRET,
                },
            }
        );

        if (!response.data || !response.data.access_token) {
            console.error("[getAccessToken] No access token in response:", response.data);
            throw new Error("No access token received");
        }

        const accessToken = response.data.access_token;
        console.log("[getAccessToken] Successfully obtained access token");
        return accessToken;
    } catch (error) {
        console.error("[getAccessToken] Error getting access token:", error.message);
        if (error.response) {
            console.error("[getAccessToken] Error response data:", error.response.data);
            console.error("[getAccessToken] Error response status:", error.response.status);
        }
        return null;
    }
}

export { getAccessToken };
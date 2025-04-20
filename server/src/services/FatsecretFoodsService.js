import axios from "axios";
import { getAccessToken } from "../utils/fatsecretAccessToken.js";
import FoodSearchModel from "../models/foods/FoodSearchModel.js";
import FoodCategoryModel from "../models/foods/FoodCategoryModel.js";
import FoodImageRecognitionModel from "../models/foods/FoodImageRecognitionModel.js";

class FatsecretFoodService {
    async search(query) {
        try {
            console.log("[FatsecretFoodService] Searching for food:", query);
            const fatsecretApiKey = await getAccessToken("basic");
            console.log("[FatsecretFoodService] Got access token successfully");

            const params = new URLSearchParams({
                method: 'foods.search',
                search_expression: query,
                format: 'json'
            });

            const url = `https://platform.fatsecret.com/rest/server.api?${params}`;
            console.log("[FatsecretFoodService] Making API request to:", url);

            const response = await axios.get(url, {
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${fatsecretApiKey}`,
                },
            });

            console.log("[FatsecretFoodService] API Response:", JSON.stringify(response.data, null, 2));

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No data found in response:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully found food data");
            return { data: FoodSearchModel.fromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error searching for food:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response data:", error.response.data);
                console.error("[FatsecretFoodService] Error response status:", error.response.status);
            }
            return {
                message: error.message || "Something went wrong",
                status: (error.response && error.response.status) || 500
            };
        }
    }

    async getCategories() {
        try {
            console.log("[FatsecretFoodService] Getting food categories");
            const fatsecretApiKey = await getAccessToken("basic");
            console.log("[FatsecretFoodService] Got access token successfully");

            const params = new URLSearchParams({
                method: 'food_categories.get.v2',
                format: 'json'
            });

            const url = `https://platform.fatsecret.com/rest/server.api?${params}`;
            console.log("[FatsecretFoodService] Making API request to:", url);

            const response = await axios.get(url, {
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${fatsecretApiKey}`,
                },
            });

            console.log("[FatsecretFoodService] API Response:", JSON.stringify(response.data, null, 2));

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No categories found in response:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully found categories");
            return { data: FoodCategoryModel.listFromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error getting categories:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response data:", error.response.data);
                console.error("[FatsecretFoodService] Error response status:", error.response.status);
            }
            return {
                message: error.message || "Something went wrong",
                status: (error.response && error.response.status) || 500
            };
        }
    }

    async imageRecognition(image_base64) {
        try {
            console.log("[FatsecretFoodService] Processing image recognition");
            const fatsecretApiKey = await getAccessToken("vision");
            console.log("[FatsecretFoodService] Got access token successfully");

            const params = new URLSearchParams({
                method: 'food.recognize_image',
                format: 'json'
            });

            const url = `https://platform.fatsecret.com/rest/server.api?${params}`;
            console.log("[FatsecretFoodService] Making API request to:", url);

            const response = await axios.post(url, {
                image_b64: image_base64,
                region: "US",
                language: "en",
            }, {
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${fatsecretApiKey}`,
                },
            });

            console.log("[FatsecretFoodService] API Response:", JSON.stringify(response.data, null, 2));

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No recognition results found:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully processed image recognition");
            return { data: FoodImageRecognitionModel.fromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error processing image recognition:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response data:", error.response.data);
                console.error("[FatsecretFoodService] Error response status:", error.response.status);
            }
            return {
                message: error.message || "Something went wrong",
                status: (error.response && error.response.status) || 500
            };
        }
    }
}

export default new FatsecretFoodService();
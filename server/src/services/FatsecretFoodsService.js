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

            if (!fatsecretApiKey) {
                throw new Error("Failed to get access token");
            }

            const response = await axios.get(
                `https://platform.fatsecret.com/rest/foods/search/v3?search_expression=${query}&format=json&region=US&language=en&include_food_attributes=true&include_sub_categories=true&include_food_images=true`, {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${fatsecretApiKey}`,
                    },
                }
            );

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No data found in response:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully found food data");
            return { data: FoodSearchModel.fromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error searching for food:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response:", error.response.data);
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

            if (!fatsecretApiKey) {
                throw new Error("Failed to get access token");
            }

            const response = await axios.get(
                `https://platform.fatsecret.com/rest/food-categories/v2?format=json&region=US&language=en`, {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${fatsecretApiKey}`,
                    },
                }
            );

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No categories found in response:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully found categories");
            return { data: FoodCategoryModel.listFromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error getting categories:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response:", error.response.data);
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

            if (!fatsecretApiKey) {
                throw new Error("Failed to get access token");
            }

            const response = await axios.post(
                `https://platform.fatsecret.com/rest/image-recognition/v1`, {
                    image_b64: image_base64,
                    region: "US",
                    language: "en",
                    include_food_data: true,
                }, {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${fatsecretApiKey}`,
                    },
                }
            );

            if (!response.data || response.data.error) {
                console.error("[FatsecretFoodService] No recognition results found:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretFoodService] Successfully processed image recognition");
            return { data: FoodImageRecognitionModel.fromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretFoodService] Error processing image recognition:", error.message);
            if (error.response) {
                console.error("[FatsecretFoodService] Error response:", error.response.data);
            }
            return {
                message: error.message || "Something went wrong",
                status: (error.response && error.response.status) || 500
            };
        }
    }
}

export default new FatsecretFoodService();
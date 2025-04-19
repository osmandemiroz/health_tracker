import axios from "axios";
import RecipeSearchModel from "../models/recipes/RecipeSearchModel.js";
import { getAccessToken } from "../utils/fatsecretAccessToken.js";

class FatsecretRecipeService {
    async search(query) {
        try {
            console.log("[FatsecretRecipeService] Searching for recipe:", query);
            const fatsecretApiKey = await getAccessToken("basic");

            if (!fatsecretApiKey) {
                throw new Error("Failed to get access token");
            }

            const response = await axios.get(
                `https://platform.fatsecret.com/rest/recipes/search/v3?search_expression=${query}&format=json&region=US&language=en`, {
                    headers: {
                        "Content-Type": "application/json",
                        Authorization: `Bearer ${fatsecretApiKey}`,
                    },
                }
            );

            if (!response.data || response.data.error) {
                console.error("[FatsecretRecipeService] No data found in response:", response.data);
                return { message: "No data found", status: 404 };
            }

            console.log("[FatsecretRecipeService] Successfully found recipe data");
            return { data: RecipeSearchModel.fromJson(response.data), status: 200 };
        } catch (error) {
            console.error("[FatsecretRecipeService] Error searching for recipe:", error.message);
            if (error.response) {
                console.error("[FatsecretRecipeService] Error response:", error.response.data);
            }
            return {
                message: error.message || "Something went wrong",
                status: (error.response && error.response.status) || 500
            };
        }
    }
}

export default new FatsecretRecipeService();
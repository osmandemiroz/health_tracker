import FoodAllergenModel from "./FoodAllergenModel.js";
import FoodPreferenceModel from "./FoodPreferenceModel.js";
import FoodServingModel from "./FoodServingModel.js";

class FoodModel {
    constructor({ food_id, food_name, brand_name, food_type, food_url, food_description }) {
        this.food_id = food_id;
        this.food_name = food_name;
        this.brand_name = brand_name;
        this.food_type = food_type;
        this.food_url = food_url;
        this.food_description = food_description;
    }

    static fromJson(json) {
        return new FoodModel({
            food_id: json.food_id,
            food_name: json.food_name,
            brand_name: json.brand_name,
            food_type: json.food_type,
            food_url: json.food_url,
            food_description: json.food_description
        });
    }
}

export default FoodModel;
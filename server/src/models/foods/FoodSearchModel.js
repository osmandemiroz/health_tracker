import FoodModel from "./FoodModel.js";

class FoodSearchModel {
    constructor({ page_number, foods }) {
        this.page_number = page_number;
        this.foods = foods;
    }

    static fromJson(json) {
        const foodsJson = json["foods"] || {};
        const foodArray = foodsJson["food"] || null;
        const pageNumber = foodsJson["page_number"] ? parseInt(foodsJson["page_number"]) : null;
        const foods = foodArray ? foodArray.map(food => FoodModel.fromJson(food)) : null;

        return new FoodSearchModel({
            page_number: pageNumber,
            foods: foods
        });
    }
}

export default FoodSearchModel;
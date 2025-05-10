// src/services/recipeService.js
import recipeModel from "../models/RecipeModel.js"; // 🚫 bu sorunlu

const getAllRecipes = () => recipeModel.getAll();
const getRecipeById = (id) => recipeModel.getById(id);
const createRecipe = (data) => recipeModel.create(data);
const deleteRecipe = (id) => recipeModel.delete(id);

module.exports = {
  getAllRecipes,
  getRecipeById,
  createRecipe,
  deleteRecipe,
};

import db from "../utils/db.js";

const numericFields = [
  "calories", "carbohydrates_g", "sugars_g", "fat_g", "saturated_fat_g",
  "cholesterol_mg", "protein_g", "dietary_fiber_g", "sodium_mg", "calories_from_fat",
  "calcium_mg", "iron_mg", "magnesium_mg", "potassium_mg", "vitamin_a_iu_IU",
  "niacin_equivalents_mg", "vitamin_c_mg", "folate_mcg", "thiamin_mg"
];

const timeFields = ["prep_time", "cook_time", "total_time"];

const getFilteredRecipes = async (filters) => {
  let query = "SELECT * FROM RECIPE WHERE 1=1";
  const params = [];

  // 1 - category (çoklu seçim)
  if (filters.category) {
    const categories = filters.category.split(","); // örn: "dessert,soup"
    const placeholders = categories.map(() => "?").join(",");
    query += ` AND category IN (${placeholders})`;
    params.push(...categories);
  }

  // 2 - title contains
  if (filters.title) {
    query += " AND title LIKE ?";
    params.push(`%${filters.title}%`);
  }

  // 3 - ingredients contains
  if (filters.ingredients) {
    query += " AND ingredients LIKE ?";
    params.push(`%${filters.ingredients}%`);
  }

  // 4 - prep_time, cook_time, total_time min/max
  timeFields.forEach(field => {
    const min = filters[`${field}_min`];
    const max = filters[`${field}_max`];
    if (min) {
      query += ` AND ${field} >= ?`;
      params.push(min);
    }
    if (max) {
      query += ` AND ${field} <= ?`;
      params.push(max);
    }
  });

  // 5 - selected numeric field with min/max
  if (filters.metric && numericFields.includes(filters.metric)) {
    const min = filters.metric_min;
    const max = filters.metric_max;
    if (min) {
      query += ` AND ${filters.metric} >= ?`;
      params.push(min);
    }
    if (max) {
      query += ` AND ${filters.metric} <= ?`;
      params.push(max);
    }
  }

  return new Promise((resolve, reject) => {
    db.all(query, params, (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
};

export default {
  getFilteredRecipes,
};

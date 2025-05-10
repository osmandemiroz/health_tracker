// src/controllers/recipeController.js
const recipeService = require("../services/recipeService");

exports.getAllRecipes = async (req, res) => {
  try {
    const recipes = await recipeService.getAllRecipes();
    res.json(recipes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getRecipeById = async (req, res) => {
  try {
    const recipe = await recipeService.getRecipeById(req.params.id);
    if (!recipe) return res.status(404).json({ message: "Recipe not found" });
    res.json(recipe);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createRecipe = async (req, res) => {
  try {
    const newRecipe = await recipeService.createRecipe(req.body);
    res.status(201).json(newRecipe);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.deleteRecipe = async (req, res) => {
  try {
    const result = await recipeService.deleteRecipe(req.params.id);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const filterRecipes = async (req, res) => {
    try {
      const filters = req.query;
      const recipes = await recipeService.getFilteredRecipes(filters);
      res.json(recipes);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: "Internal Server Error" });
    }
  };

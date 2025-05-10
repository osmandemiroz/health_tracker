// src/routes/recipeRoutes.js
const express = require("express");
const router = express.Router();
const recipeController = require("../controllers/recipeController");
import { filterRecipes } from "../controllers/recipeController.js";

router.get("/", recipeController.getAllRecipes);
router.get("/:id", recipeController.getRecipeById);
router.post("/", recipeController.createRecipe);
router.delete("/:id", recipeController.deleteRecipe);
router.get("/filter", filterRecipes); // GET /api/v1/recipes/filter

module.exports = router;

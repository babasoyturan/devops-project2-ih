import { createContext } from 'react';
import type { BurgerLayer, Ingredient } from '../types';

export interface BurgerBuilderContextType {
  layers: BurgerLayer[];
  ingredients: Ingredient[];
  setIngredients: (ingredients: Ingredient[]) => void;
  addLayer: (ingredientId: number) => void;
  removeLayer: (index: number) => void;
  clearLayers: () => void;
  getTotalPrice: () => number;
  getIngredientById: (id: number) => Ingredient | undefined;
}

export const BurgerBuilderContext = createContext<BurgerBuilderContextType | undefined>(undefined);

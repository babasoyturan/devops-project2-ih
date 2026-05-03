import React, { useCallback, useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import type { BurgerLayer, Ingredient } from '../types';
import { BurgerBuilderContext } from './burgerBuilderContext';

const addIngredientLayer = (layers: BurgerLayer[], ingredientId: number): BurgerLayer[] => {
  const existingLayer = layers.find((layer) => layer.ingredientId === ingredientId);

  if (!existingLayer) {
    return [...layers, { ingredientId, quantity: 1 }];
  }

  return layers.map((layer) =>
    layer.ingredientId === ingredientId
      ? { ...layer, quantity: layer.quantity + 1 }
      : layer
  );
};

const removeIngredientLayer = (layers: BurgerLayer[], index: number): BurgerLayer[] => {
  const layer = layers[index];

  if (!layer) {
    return layers;
  }

  if (layer.quantity > 1) {
    return layers.map((existingLayer, layerIndex) =>
      layerIndex === index
        ? { ...existingLayer, quantity: existingLayer.quantity - 1 }
        : existingLayer
    );
  }

  return layers.filter((_, layerIndex) => layerIndex !== index);
};

const findIngredientById = (ingredients: Ingredient[], id: number): Ingredient | undefined => {
  return ingredients.find((ingredient) => ingredient.id === id);
};

const calculateBurgerTotal = (layers: BurgerLayer[], ingredients: Ingredient[]): number => {
  return layers.reduce((total, layer) => {
    const ingredient = findIngredientById(ingredients, layer.ingredientId);
    return total + (ingredient ? ingredient.price * layer.quantity : 0);
  }, 0);
};

export const BurgerBuilderProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [layers, setLayers] = useState<BurgerLayer[]>([]);
  const [ingredients, setIngredients] = useState<Ingredient[]>([]);

  const addLayer = useCallback((ingredientId: number) => {
    setLayers((prevLayers) => addIngredientLayer(prevLayers, ingredientId));
  }, []);

  const removeLayer = useCallback((index: number) => {
    setLayers((prevLayers) => removeIngredientLayer(prevLayers, index));
  }, []);

  const clearLayers = useCallback(() => {
    setLayers([]);
  }, []);

  const getIngredientById = useCallback((id: number): Ingredient | undefined => {
    return findIngredientById(ingredients, id);
  }, [ingredients]);

  const getTotalPrice = useCallback((): number => {
    return calculateBurgerTotal(layers, ingredients);
  }, [ingredients, layers]);

  const value = useMemo(() => ({
    layers,
    ingredients,
    setIngredients,
    addLayer,
    removeLayer,
    clearLayers,
    getTotalPrice,
    getIngredientById,
  }), [addLayer, clearLayers, getIngredientById, getTotalPrice, ingredients, layers, removeLayer]);

  return (
    <BurgerBuilderContext.Provider value={value}>
      {children}
    </BurgerBuilderContext.Provider>
  );
};

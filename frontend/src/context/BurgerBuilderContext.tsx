import React, { useState } from 'react';
import type { ReactNode } from 'react';
import type { BurgerLayer, Ingredient } from '../types';
import { BurgerBuilderContext } from './burgerBuilderContext';

export const BurgerBuilderProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [layers, setLayers] = useState<BurgerLayer[]>([]);
  const [ingredients, setIngredients] = useState<Ingredient[]>([]);

  const addLayer = (ingredientId: number) => {
    setLayers((prevLayers) => {
      const existingLayer = prevLayers.find(layer => layer.ingredientId === ingredientId);
      
      if (existingLayer) {
        return prevLayers.map(layer =>
          layer.ingredientId === ingredientId
            ? { ...layer, quantity: layer.quantity + 1 }
            : layer
        );
      }
      
      return [...prevLayers, { ingredientId, quantity: 1 }];
    });
  };

  const removeLayer = (index: number) => {
    setLayers((prevLayers) => {
      const layer = prevLayers[index];
      
      if (layer.quantity > 1) {
        return prevLayers.map((l, i) =>
          i === index ? { ...l, quantity: l.quantity - 1 } : l
        );
      }
      
      return prevLayers.filter((_, i) => i !== index);
    });
  };

  const clearLayers = () => {
    setLayers([]);
  };

  const getIngredientById = (id: number): Ingredient | undefined => {
    return ingredients.find(ing => ing.id === id);
  };

  const getTotalPrice = (): number => {
    return layers.reduce((total, layer) => {
      const ingredient = getIngredientById(layer.ingredientId);
      return total + (ingredient ? ingredient.price * layer.quantity : 0);
    }, 0);
  };

  return (
    <BurgerBuilderContext.Provider
      value={{
        layers,
        ingredients,
        setIngredients,
        addLayer,
        removeLayer,
        clearLayers,
        getTotalPrice,
        getIngredientById,
      }}
    >
      {children}
    </BurgerBuilderContext.Provider>
  );
};

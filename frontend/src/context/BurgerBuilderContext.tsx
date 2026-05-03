import React, { useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import type { BurgerLayer, Ingredient } from '../types';
import { BurgerBuilderContext } from './burgerBuilderContext';

export const BurgerBuilderProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [layers, setLayers] = useState<BurgerLayer[]>([]);
  const [ingredients, setIngredients] = useState<Ingredient[]>([]);

  const value = useMemo(() => {
    const addLayer = (ingredientId: number) => {
      setLayers((prevLayers) => {
        const existingLayer = prevLayers.find((layer) => layer.ingredientId === ingredientId);

        if (existingLayer) {
          return prevLayers.map((layer) =>
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

        if (!layer) {
          return prevLayers;
        }

        if (layer.quantity > 1) {
          return prevLayers.map((existingLayer, layerIndex) =>
            layerIndex === index
              ? { ...existingLayer, quantity: existingLayer.quantity - 1 }
              : existingLayer
          );
        }

        return prevLayers.filter((_, layerIndex) => layerIndex !== index);
      });
    };

    const clearLayers = () => {
      setLayers([]);
    };

    const getIngredientById = (id: number): Ingredient | undefined => {
      return ingredients.find((ingredient) => ingredient.id === id);
    };

    const getTotalPrice = (): number => {
      return layers.reduce((total, layer) => {
        const ingredient = getIngredientById(layer.ingredientId);
        return total + (ingredient ? ingredient.price * layer.quantity : 0);
      }, 0);
    };

    return {
      layers,
      ingredients,
      setIngredients,
      addLayer,
      removeLayer,
      clearLayers,
      getTotalPrice,
      getIngredientById,
    };
  }, [ingredients, layers]);

  return (
    <BurgerBuilderContext.Provider value={value}>
      {children}
    </BurgerBuilderContext.Provider>
  );
};

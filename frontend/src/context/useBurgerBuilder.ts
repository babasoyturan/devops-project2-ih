import { useContext } from 'react';
import { BurgerBuilderContext } from './burgerBuilderContext';
import type { BurgerBuilderContextType } from './burgerBuilderContext';

export const useBurgerBuilder = (): BurgerBuilderContextType => {
  const context = useContext(BurgerBuilderContext);
  if (!context) {
    throw new Error('useBurgerBuilder must be used within a BurgerBuilderProvider');
  }
  return context;
};

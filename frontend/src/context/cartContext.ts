import { createContext } from 'react';
import type { CartItem } from '../types';

export interface CartContextType {
  cart: CartItem[];
  addItemToCart: (item: CartItem) => void;
  removeItemFromCart: (itemId: number) => void;
  updateItemQuantity: (itemId: number, quantity: number) => void;
  clearCart: () => void;
  getTotalPrice: () => number;
  getTotalItems: () => number;
}

export const CartContext = createContext<CartContextType | undefined>(undefined);

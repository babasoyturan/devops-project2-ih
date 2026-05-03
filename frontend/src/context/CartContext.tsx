import React, { useCallback, useEffect, useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import type { CartItem } from '../types';
import { CartContext } from './cartContext';

const updateCartItemQuantity = (cart: CartItem[], itemId: number, quantity: number): CartItem[] => {
  return cart.map((item) =>
    item.id === itemId ? { ...item, quantity } : item
  );
};

const calculateCartTotalPrice = (cart: CartItem[]): number => {
  return cart.reduce((total, item) => total + item.totalPrice * item.quantity, 0);
};

const calculateCartTotalItems = (cart: CartItem[]): number => {
  return cart.reduce((total, item) => total + item.quantity, 0);
};

export const CartProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [cart, setCart] = useState<CartItem[]>([]);

  // Load cart from localStorage on mount
  useEffect(() => {
    const savedCart = localStorage.getItem('cart');
    if (savedCart) {
      try {
        setCart(JSON.parse(savedCart));
      } catch (error) {
        console.error('Failed to parse cart from localStorage', error);
      }
    }
  }, []);

  // Save cart to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem('cart', JSON.stringify(cart));
  }, [cart]);

  const addItemToCart = useCallback((item: CartItem) => {
    setCart((prevCart) => [...prevCart, item]);
  }, []);

  const removeItemFromCart = useCallback((itemId: number) => {
    setCart((prevCart) => prevCart.filter((item) => item.id !== itemId));
  }, []);

  const updateItemQuantity = useCallback((itemId: number, quantity: number) => {
    if (quantity <= 0) {
      removeItemFromCart(itemId);
      return;
    }

    setCart((prevCart) => updateCartItemQuantity(prevCart, itemId, quantity));
  }, [removeItemFromCart]);

  const clearCart = useCallback(() => {
    setCart([]);
  }, []);

  const getTotalPrice = useCallback((): number => {
    return calculateCartTotalPrice(cart);
  }, [cart]);

  const getTotalItems = useCallback((): number => {
    return calculateCartTotalItems(cart);
  }, [cart]);

  const value = useMemo(() => ({
    cart,
    addItemToCart,
    removeItemFromCart,
    updateItemQuantity,
    clearCart,
    getTotalPrice,
    getTotalItems,
  }), [addItemToCart, cart, clearCart, getTotalItems, getTotalPrice, removeItemFromCart, updateItemQuantity]);

  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
};

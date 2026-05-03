import { describe, expect, it, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import BurgerPreview from './BurgerPreview';
import type { BurgerLayer, Ingredient } from '../../types';

describe('BurgerPreview', () => {
  const ingredients: Ingredient[] = [
    {
      id: 1,
      name: 'Beef Patty',
      category: 'patties',
      price: 5.99,
      imageUrl: 'patty.jpg',
    },
  ];

  const getIngredientById = (id: number) => {
    return ingredients.find((ingredient) => ingredient.id === id);
  };

  it('renders removable layers as buttons', () => {
    const layers: BurgerLayer[] = [{ ingredientId: 1, quantity: 1 }];

    render(
      <BurgerPreview
        layers={layers}
        getIngredientById={getIngredientById}
        onRemoveLayer={vi.fn()}
      />
    );

    expect(
      screen.getByRole('button', { name: 'Remove Beef Patty layer' })
    ).toBeInTheDocument();
  });

  it('removes a layer when its button is clicked', async () => {
    const user = userEvent.setup();
    const onRemoveLayer = vi.fn();
    const layers: BurgerLayer[] = [{ ingredientId: 1, quantity: 1 }];

    render(
      <BurgerPreview
        layers={layers}
        getIngredientById={getIngredientById}
        onRemoveLayer={onRemoveLayer}
      />
    );

    await user.click(screen.getByRole('button', { name: 'Remove Beef Patty layer' }));

    expect(onRemoveLayer).toHaveBeenCalledWith(0);
  });
});

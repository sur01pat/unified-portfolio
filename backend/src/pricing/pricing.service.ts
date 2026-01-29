import { Injectable } from '@nestjs/common';

@Injectable()
export class PricingService {
  // 🔹 base market price
  private baseGoldPrice = 6800;

  // 🔹 cache
  private cachedPrices: any = null;
  private lastFetchedAt = 0;
  private readonly TTL_MS = 30 * 1000; // 30s

  private simulateGoldPrice(): number {
    // ±0.5% random movement
    const movement =
      (Math.random() - 0.5) * 0.01 * this.baseGoldPrice;

    this.baseGoldPrice = Number(
      (this.baseGoldPrice + movement).toFixed(2),
    );

    return this.baseGoldPrice;
  }

  async getPrices() {
    const now = Date.now();

    if (
      this.cachedPrices &&
      now - this.lastFetchedAt < this.TTL_MS
    ) {
      return this.cachedPrices;
    }

    const goldPrice = this.simulateGoldPrice();

    this.cachedPrices = {
      GOLD: {
        pricePerGram: goldPrice,
        currency: 'INR',
        updatedAt: new Date(),
        source: 'SIMULATED_MARKET',
      },
    };

    this.lastFetchedAt = now;

    return this.cachedPrices;
  }
}



import { Injectable } from '@nestjs/common';
import { Asset, AssetType, AssetSource } from './asset.entity';
import { CreateAssetDto } from './dto/create-asset.dto';
import { v4 as uuid } from 'uuid';
import { PricingService } from '../pricing/pricing.service';

@Injectable()
export class PortfolioService {
  private assets: Asset[] = [];

  constructor(
    private readonly pricingService: PricingService,
  ) {}

  create(userId: string, dto: CreateAssetDto): Asset {
    const asset: Asset = {
      id: uuid(),
      userId,
      createdAt: new Date(),
      ...dto,
    };
    this.assets.push(asset);
    return asset;
  }

  findAll(userId: string): Asset[] {
    return this.assets.filter(a => a.userId === userId);
  }

  delete(userId: string, assetId: string): void {
    this.assets = this.assets.filter(
      a => !(a.userId === userId && a.id === assetId),
    );
  }

  /// 🔹 PORTFOLIO SUMMARY
  async getSummary(userId: string) {
    const prices = await this.pricingService.getPrices();
    const goldPrice = prices.GOLD.pricePerGram;

    let investedValue = 0;
    let currentValue = 0;

    for (const a of this.findAll(userId)) {
      const invested = a.quantity * a.purchasePrice;
      investedValue += invested;

      if (a.type === AssetType.GOLD) {
        currentValue += a.quantity * goldPrice;
      } else {
        currentValue += invested;
      }
    }

    return {
      investedValue,
      currentValue,
      pnl: currentValue - investedValue,
      priceTimestamp: prices.GOLD.updatedAt,
    };
  }

  // ------------------------------------------------------------------
  // 🔹 DEV ONLY: SYNTHETIC DATA SEED (ENUM SAFE)
  // ------------------------------------------------------------------
  seedSyntheticData(userId: string) {
    this.assets = this.assets.filter(a => a.userId !== userId);

    const today = new Date();
    const daysFromNow = (d: number) =>
      new Date(today.getTime() + d * 24 * 60 * 60 * 1000);

    const syntheticAssets: Partial<Asset>[] = [
      // 🇺🇸 US Tech Stocks
      {
        type: AssetType.STOCK,
        source: AssetSource.BROKER,
        name: 'Apple',
        quantity: 10,
        purchasePrice: 180,
        currency: 'USD',
        country: 'US',
        sector: 'Technology',
        platform: 'Broker',
      },
      {
        type: AssetType.STOCK,
        source: AssetSource.BROKER,
        name: 'Microsoft',
        quantity: 8,
        purchasePrice: 330,
        currency: 'USD',
        country: 'US',
        sector: 'Technology',
        platform: 'Broker',
      },

      // 🇮🇳 Indian Banking
      {
        type: AssetType.STOCK,
        source: AssetSource.BROKER,
        name: 'HDFC Bank',
        quantity: 50,
        purchasePrice: 1500,
        currency: 'INR',
        country: 'India',
        sector: 'Banking',
        platform: 'Broker',
      },

      // 🟡 Gold (Manual)
      {
        type: AssetType.GOLD,
        source: AssetSource.MANUAL,
        name: 'Physical Gold',
        quantity: 100,
        purchasePrice: 6200,
        currency: 'INR',
        country: 'India',
        sector: 'Commodities',
      },

      // 💵 Cash (Manual)
      {
        type: AssetType.CASH,
        source: AssetSource.MANUAL,
        name: 'Savings Account',
        quantity: 500000,
        purchasePrice: 1,
        currency: 'INR',
        country: 'India',
        sector: 'Cash',
      },

      // 🏠 Real Estate (Manual)
      {
        type: AssetType.REAL_ESTATE,
        source: AssetSource.MANUAL,
        name: 'Apartment',
        quantity: 1,
        purchasePrice: 8000000,
        currency: 'INR',
        country: 'India',
        sector: 'Real Assets',
      },

      // 🏦 FD — DUE SOON
      {
        type: AssetType.FIXED_INCOME,
        source: AssetSource.BANK,
        name: 'ICICI Bank FD',
        quantity: 1,
        purchasePrice: 500000,
        currency: 'INR',
        platform: 'ICICI Bank',
        startDate: daysFromNow(-350),
        maturityDate: daysFromNow(15),
        interestRate: 6.9,
        country: 'India',
        sector: 'Debt',
      },

      // 🏦 FD — ACTIVE
      {
        type: AssetType.FIXED_INCOME,
        source: AssetSource.BANK,
        name: 'HDFC Bank FD',
        quantity: 1,
        purchasePrice: 300000,
        currency: 'INR',
        platform: 'HDFC Bank',
        startDate: daysFromNow(-200),
        maturityDate: daysFromNow(60),
        interestRate: 6.7,
        country: 'India',
        sector: 'Debt',
      },

      // 🏦 FD — MATURED
      {
        type: AssetType.FIXED_INCOME,
        source: AssetSource.BANK,
        name: 'SBI Bank FD',
        quantity: 1,
        purchasePrice: 250000,
        currency: 'INR',
        platform: 'SBI Bank',
        startDate: daysFromNow(-400),
        maturityDate: daysFromNow(-5),
        interestRate: 6.5,
        country: 'India',
        sector: 'Debt',
      },
    ];

    syntheticAssets.forEach(dto =>
      this.create(userId, dto as CreateAssetDto),
    );

    return { seeded: true };
  }
}




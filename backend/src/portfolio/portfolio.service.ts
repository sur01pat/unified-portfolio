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
    this.assets = [];//added
    this.assets = this.assets.filter(a => a.userId !== userId);

    const today = new Date();
    const daysFromNow = (d: number) =>
      new Date(today.getTime() + d * 24 * 60 * 60 * 1000);

    // const syntheticAssets: Partial<Asset>[] = [
    //   // 🇺🇸 US Tech Stocks
    //   {
    //     type: AssetType.STOCK,
    //     source: AssetSource.BROKER,
    //     name: 'Apple',
    //     quantity: 10,
    //     purchasePrice: 180,
    //     currency: 'USD',
    //     country: 'US',
    //     sector: 'Technology',
    //     platform: 'Broker',
    //   },
    //   {
    //     type: AssetType.STOCK,
    //     source: AssetSource.BROKER,
    //     name: 'Microsoft',
    //     quantity: 8,
    //     purchasePrice: 330,
    //     currency: 'USD',
    //     country: 'US',
    //     sector: 'Technology',
    //     platform: 'Broker',
    //   },

    //   // 🇮🇳 Indian Banking
    //   {
    //     type: AssetType.STOCK,
    //     source: AssetSource.BROKER,
    //     name: 'HDFC Bank',
    //     quantity: 50,
    //     purchasePrice: 1500,
    //     currency: 'INR',
    //     country: 'India',
    //     sector: 'Banking',
    //     platform: 'Broker',
    //   },

    //   // 🟡 Gold (Manual)
    //   {
    //     type: AssetType.GOLD,
    //     source: AssetSource.MANUAL,
    //     name: 'Physical Gold',
    //     quantity: 100,
    //     purchasePrice: 6200,
    //     currency: 'INR',
    //     country: 'India',
    //     sector: 'Commodities',
    //   },

    //   // 💵 Cash (Manual)
    //   {
    //     type: AssetType.CASH,
    //     source: AssetSource.MANUAL,
    //     name: 'Savings Account',
    //     quantity: 500000,
    //     purchasePrice: 1,
    //     currency: 'INR',
    //     country: 'India',
    //     sector: 'Cash',
    //   },

    //   // 🏠 Real Estate (Manual)
    //   {
    //     type: AssetType.REAL_ESTATE,
    //     source: AssetSource.MANUAL,
    //     name: 'Apartment',
    //     quantity: 1,
    //     purchasePrice: 8000000,
    //     currency: 'INR',
    //     country: 'India',
    //     sector: 'Real Assets',
    //   },

    //   // 🏦 FD — DUE SOON
    //   {
    //     type: AssetType.FIXED_INCOME,
    //     source: AssetSource.BANK,
    //     name: 'ICICI Bank FD',
    //     quantity: 1,
    //     purchasePrice: 500000,
    //     currency: 'INR',
    //     platform: 'ICICI Bank',
    //     startDate: daysFromNow(-350),
    //     maturityDate: daysFromNow(15),
    //     interestRate: 6.9,
    //     country: 'India',
    //     sector: 'Debt',
    //   },

    //   // 🏦 FD — ACTIVE
    //   {
    //     type: AssetType.FIXED_INCOME,
    //     source: AssetSource.BANK,
    //     name: 'HDFC Bank FD',
    //     quantity: 1,
    //     purchasePrice: 300000,
    //     currency: 'INR',
    //     platform: 'HDFC Bank',
    //     startDate: daysFromNow(-200),
    //     maturityDate: daysFromNow(60),
    //     interestRate: 6.7,
    //     country: 'India',
    //     sector: 'Debt',
    //   },

    //   // 🏦 FD — MATURED
    //   {
    //     type: AssetType.FIXED_INCOME,
    //     source: AssetSource.BANK,
    //     name: 'SBI Bank FD',
    //     quantity: 1,
    //     purchasePrice: 250000,
    //     currency: 'INR',
    //     platform: 'SBI Bank',
    //     startDate: daysFromNow(-400),
    //     maturityDate: daysFromNow(-5),
    //     interestRate: 6.5,
    //     country: 'India',
    //     sector: 'Debt',
    //   },
    // ];
    const syntheticAssets: Partial<Asset>[] = [

    /* ============================
      🇺🇸 US BIG TECH (10)
    ============================ */

    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Apple', quantity: 20, purchasePrice: 175, currency: 'USD', country: 'US', sector: 'Technology', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Microsoft', quantity: 18, purchasePrice: 320, currency: 'USD', country: 'US', sector: 'Technology', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Amazon', quantity: 12, purchasePrice: 145, currency: 'USD', country: 'US', sector: 'E-Commerce', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Google', quantity: 15, purchasePrice: 140, currency: 'USD', country: 'US', sector: 'Technology', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Meta', quantity: 14, purchasePrice: 290, currency: 'USD', country: 'US', sector: 'Technology', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Tesla', quantity: 10, purchasePrice: 250, currency: 'USD', country: 'US', sector: 'Automobile', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Nvidia', quantity: 9, purchasePrice: 720, currency: 'USD', country: 'US', sector: 'Semiconductors', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Netflix', quantity: 8, purchasePrice: 430, currency: 'USD', country: 'US', sector: 'Media', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Adobe', quantity: 7, purchasePrice: 520, currency: 'USD', country: 'US', sector: 'Software', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Salesforce', quantity: 11, purchasePrice: 210, currency: 'USD', country: 'US', sector: 'Cloud', platform: 'Robinhood' },

    /* ============================
      📊 ETFs (10)
    ============================ */

    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'S&P 500 ETF', quantity: 30, purchasePrice: 450, currency: 'USD', country: 'US', sector: 'Index', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'NASDAQ ETF', quantity: 25, purchasePrice: 390, currency: 'USD', country: 'US', sector: 'Index', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Dow Jones ETF', quantity: 20, purchasePrice: 350, currency: 'USD', country: 'US', sector: 'Index', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Russell 2000 ETF', quantity: 15, purchasePrice: 210, currency: 'USD', country: 'US', sector: 'Index', platform: 'Robinhood' },
    { type: AssetType.STOCK, source: AssetSource.BROKER, name: 'Vanguard Total Market ETF', quantity: 18, purchasePrice: 240, currency: 'USD', country: 'US', sector: 'Index', platform: 'Robinhood' },

    /* ============================
      🟡 GOLD (5)
    ============================ */

    { type: AssetType.GOLD, source: AssetSource.MANUAL, name: 'Gold Bar', quantity: 100, purchasePrice: 72, currency: 'USD', country: 'US', sector: 'Commodities' },
    { type: AssetType.GOLD, source: AssetSource.MANUAL, name: 'Gold Coins', quantity: 50, purchasePrice: 74, currency: 'USD', country: 'US', sector: 'Commodities' },
    { type: AssetType.GOLD, source: AssetSource.MANUAL, name: 'Jewelry Gold', quantity: 30, purchasePrice: 70, currency: 'USD', country: 'US', sector: 'Commodities' },
    { type: AssetType.GOLD, source: AssetSource.MANUAL, name: 'Digital Gold', quantity: 40, purchasePrice: 73, currency: 'USD', country: 'US', sector: 'Commodities' },
    { type: AssetType.GOLD, source: AssetSource.MANUAL, name: 'Gold ETF Units', quantity: 60, purchasePrice: 71, currency: 'USD', country: 'US', sector: 'Commodities' },

    /* ============================
      💵 CASH (5)
    ============================ */

    { type: AssetType.CASH, source: AssetSource.MANUAL, name: 'Checking Account', quantity: 30000, purchasePrice: 1, currency: 'USD', country: 'US', sector: 'Cash' },
    { type: AssetType.CASH, source: AssetSource.MANUAL, name: 'Savings Account', quantity: 50000, purchasePrice: 1, currency: 'USD', country: 'US', sector: 'Cash' },
    { type: AssetType.CASH, source: AssetSource.MANUAL, name: 'Emergency Fund', quantity: 20000, purchasePrice: 1, currency: 'USD', country: 'US', sector: 'Cash' },
    { type: AssetType.CASH, source: AssetSource.MANUAL, name: 'Vacation Fund', quantity: 10000, purchasePrice: 1, currency: 'USD', country: 'US', sector: 'Cash' },
    { type: AssetType.CASH, source: AssetSource.MANUAL, name: 'Broker Cash', quantity: 15000, purchasePrice: 1, currency: 'USD', country: 'US', sector: 'Cash' },

    /* ============================
      🏠 REAL ESTATE (5)
    ============================ */

    { type: AssetType.REAL_ESTATE, source: AssetSource.MANUAL, name: 'Rental Home - Texas', quantity: 1, purchasePrice: 320000, currency: 'USD', country: 'US', sector: 'Real Estate' },
    { type: AssetType.REAL_ESTATE, source: AssetSource.MANUAL, name: 'Condo - Florida', quantity: 1, purchasePrice: 280000, currency: 'USD', country: 'US', sector: 'Real Estate' },
    { type: AssetType.REAL_ESTATE, source: AssetSource.MANUAL, name: 'Duplex - Ohio', quantity: 1, purchasePrice: 250000, currency: 'USD', country: 'US', sector: 'Real Estate' },
    { type: AssetType.REAL_ESTATE, source: AssetSource.MANUAL, name: 'Commercial Shop', quantity: 1, purchasePrice: 450000, currency: 'USD', country: 'US', sector: 'Real Estate' },
    { type: AssetType.REAL_ESTATE, source: AssetSource.MANUAL, name: 'Land Plot', quantity: 1, purchasePrice: 150000, currency: 'USD', country: 'US', sector: 'Real Estate' },

    /* ============================
      🏦 FIXED INCOME / CDs (10)
    ============================ */

    { type: AssetType.FIXED_INCOME, source: AssetSource.BANK, name: 'Chase CD', quantity: 1, purchasePrice: 25000, currency: 'USD', platform: 'Chase', startDate: daysFromNow(-300), maturityDate: daysFromNow(60), interestRate: 4.7, country: 'US', sector: 'Debt' },
    { type: AssetType.FIXED_INCOME, source: AssetSource.BANK, name: 'BoA CD', quantity: 1, purchasePrice: 20000, currency: 'USD', platform: 'Bank of America', startDate: daysFromNow(-200), maturityDate: daysFromNow(90), interestRate: 4.5, country: 'US', sector: 'Debt' },
    { type: AssetType.FIXED_INCOME, source: AssetSource.BANK, name: 'Wells Fargo CD', quantity: 1, purchasePrice: 18000, currency: 'USD', platform: 'Wells Fargo', startDate: daysFromNow(-150), maturityDate: daysFromNow(120), interestRate: 4.4, country: 'US', sector: 'Debt' },
    { type: AssetType.FIXED_INCOME, source: AssetSource.BANK, name: 'Capital One CD', quantity: 1, purchasePrice: 30000, currency: 'USD', platform: 'Capital One', startDate: daysFromNow(-350), maturityDate: daysFromNow(30), interestRate: 4.9, country: 'US', sector: 'Debt' },
    { type: AssetType.FIXED_INCOME, source: AssetSource.BANK, name: 'Ally Bank CD', quantity: 1, purchasePrice: 22000, currency: 'USD', platform: 'Ally', startDate: daysFromNow(-180), maturityDate: daysFromNow(150), interestRate: 4.6, country: 'US', sector: 'Debt' },
    ];


    syntheticAssets.forEach(dto =>
      this.create(userId, dto as CreateAssetDto),
    );

    return { seeded: true };
  }
}




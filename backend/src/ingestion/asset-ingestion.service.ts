import { Injectable } from '@nestjs/common';
import { PortfolioService } from '../portfolio/portfolio.service';
import { AssetType, AssetSource } from '../portfolio/asset.entity';

@Injectable()
export class AssetIngestionService {
  constructor(
    private readonly portfolioService: PortfolioService,
  ) {}

  ingestFromBroker(userId: string) {
    const brokerAssets = [
      {
        type: AssetType.STOCK,
        source: AssetSource.BROKER,
        name: 'Tesla',
        quantity: 5,
        purchasePrice: 250,
        currency: 'USD',
        country: 'US',
        sector: 'Automotive',
        platform: 'Zerodha',
      },
    ];

    brokerAssets.forEach(dto =>
      this.portfolioService.create(userId, dto as any),
    );

    return brokerAssets;
  }

  ingestFromBank(userId: string) {
    const bankAssets = [
      {
        type: AssetType.FIXED_INCOME,
        source: AssetSource.BANK,
        name: 'Axis Bank FD',
        quantity: 1,
        purchasePrice: 400000,
        currency: 'INR',
        platform: 'Axis Bank',
        maturityDate: new Date(
          Date.now() + 45 * 24 * 60 * 60 * 1000,
        ),
        interestRate: 6.8,
        country: 'India',
        sector: 'Debt',
      },
    ];

    bankAssets.forEach(dto =>
      this.portfolioService.create(userId, dto as any),
    );

    return bankAssets;
  }
}

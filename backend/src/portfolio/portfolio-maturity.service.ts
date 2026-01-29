import { Injectable } from '@nestjs/common';
import { PortfolioService } from './portfolio.service';

@Injectable()
export class PortfolioMaturityService {
  constructor(
    private readonly portfolioService: PortfolioService,
  ) {}

  getMaturities(userId: string) {
    const assets = this.portfolioService.findAll(userId);

    const today = new Date();

    const fixedIncome = assets.filter(
      a => a.type === 'FIXED_INCOME' && a.maturityDate,
    );

    return fixedIncome.map(a => {
      const maturity = new Date(a.maturityDate!);
      const daysRemaining = Math.ceil(
        (maturity.getTime() - today.getTime()) /
          (1000 * 60 * 60 * 24),
      );

      return {
        id: a.id,
        name: a.name,
        amount: a.purchasePrice,
        maturityDate: a.maturityDate,
        daysRemaining,
        status:
          daysRemaining < 0
            ? 'MATURED'
            : daysRemaining <= 30
            ? 'DUE_SOON'
            : 'ACTIVE',
      };
    });
  }
}

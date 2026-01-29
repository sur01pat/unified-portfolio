import { Injectable } from '@nestjs/common';
import { PortfolioService } from './portfolio.service';
import { Asset } from './asset.entity';

@Injectable()
export class PortfolioAnalysisService {
  constructor(
    private readonly portfolioService: PortfolioService,
  ) {}

  analyze(userId: string) {
    const assets = this.portfolioService.findAll(userId);

    if (assets.length === 0) {
      return {
        allocation: {},
        countryExposure: {},
        sectorExposure: {},
        warnings: [],
      };
    }

    const totalValue = assets.reduce(
      (sum, a) => sum + a.quantity * a.purchasePrice,
      0,
    );

    const allocation: Record<string, number> = {};
    const countryExposure: Record<string, number> = {};
    const sectorExposure: Record<string, number> = {};

    for (const a of assets) {
      const value = a.quantity * a.purchasePrice;

      // 🔹 Asset class mapping (A)
      const bucket = this.mapAssetClass(a.type);
      allocation[bucket] =
        (allocation[bucket] || 0) + value;

      // 🔹 Country
      if (a.country) {
        countryExposure[a.country] =
          (countryExposure[a.country] || 0) + value;
      }

      // 🔹 Sector
      if (a.sector) {
        sectorExposure[a.sector] =
          (sectorExposure[a.sector] || 0) + value;
      }
    }

    // Convert to percentages
    const allocationPct = this.toPct(allocation, totalValue);
    const countryPct = this.toPct(countryExposure, totalValue);
    const sectorPct = this.toPct(sectorExposure, totalValue);

    // 🔥 Warnings
    const warnings = this.generateWarnings(
      allocationPct,
      countryPct,
    );

    return {
      allocation: allocationPct,
      countryExposure: countryPct,
      sectorExposure: sectorPct,
      warnings,
    };
  }

  private mapAssetClass(type: string): string {
    switch (type) {
      case 'STOCK':
        return 'Equity';
      case 'FIXED_INCOME':
        return 'Debt';
      case 'GOLD':
        return 'Gold';
      case 'CASH':
        return 'Cash';
      case 'REAL_ESTATE':
        return 'Real Assets';
      default:
        return 'Other';
    }
  }

  private toPct(
    data: Record<string, number>,
    total: number,
  ) {
    const result: Record<string, number> = {};
    for (const k of Object.keys(data)) {
      result[k] = Number(
        ((data[k] / total) * 100).toFixed(1),
      );
    }
    return result;
  }

  private generateWarnings(
    allocation: Record<string, number>,
    country: Record<string, number>,
  ): string[] {
    const warnings: string[] = [];

    // Equity concentration
    if ((allocation['Equity'] || 0) > 70) {
      warnings.push(
        'High equity exposure (>70%). Consider diversification.',
      );
    }

    // Country concentration
    for (const c of Object.keys(country)) {
      if (country[c] > 60) {
        warnings.push(
          `High exposure to ${c} markets (>60%).`,
        );
      }
    }

    // Gold concentration
    if ((allocation['Gold'] || 0) > 25) {
      warnings.push(
        'Gold allocation above recommended range (>25%).',
      );
    }

    return warnings;
  }
}

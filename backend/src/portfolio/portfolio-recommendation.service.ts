import { Injectable } from '@nestjs/common';
import { PortfolioAnalysisService } from './portfolio-analysis.service';

@Injectable()
export class PortfolioRecommendationService {
  constructor(
    private readonly analysisService: PortfolioAnalysisService,
  ) {}

  getRecommendations(userId: string) {
    const analysis = this.analysisService.analyze(userId);

    const recs: any[] = [];

    const allocation = analysis.allocation;
    const country = analysis.countryExposure;

    // 🔹 Equity overexposure
    if ((allocation['Equity'] || 0) > 70) {
      recs.push({
        action: 'Reduce Equity Exposure',
        recommendation:
          'Consider reducing equity allocation by 10–15% to lower volatility.',
        severity: 'HIGH',
        rationale: `Equity allocation is ${allocation['Equity']}%, which is above the recommended range.`,
      });
    }

    // 🔹 Low Debt exposure
    if ((allocation['Debt'] || 0) < 20) {
      recs.push({
        action: 'Increase Debt Allocation',
        recommendation:
          'Adding debt instruments can help stabilize portfolio returns.',
        severity: 'MEDIUM',
        rationale: `Debt allocation is only ${allocation['Debt'] || 0}%.`,
      });
    }

    // 🔹 Gold concentration
    if ((allocation['Gold'] || 0) > 25) {
      recs.push({
        action: 'Rebalance Gold Holdings',
        recommendation:
          'Gold allocation is high; consider reallocating part into equity or debt.',
        severity: 'MEDIUM',
        rationale: `Gold allocation is ${allocation['Gold']}%.`,
      });
    }

    // 🔹 Country concentration
    for (const c of Object.keys(country)) {
      if (country[c] > 60) {
        recs.push({
          action: 'Diversify Geographically',
          recommendation:
            `Reduce exposure to ${c} and consider adding assets from other regions.`,
          severity: 'HIGH',
          rationale: `${c} exposure is ${country[c]}%.`,
        });
      }
    }

    return recs;
  }
}

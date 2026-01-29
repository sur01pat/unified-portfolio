import { Module } from '@nestjs/common';
import { PortfolioService } from './portfolio.service';
import { PortfolioController } from './portfolio.controller';
import { PortfolioAnalysisService } from './portfolio-analysis.service';
import { PortfolioMaturityService } from './portfolio-maturity.service';
import { PortfolioRecommendationService } from './portfolio-recommendation.service';
import { PricingModule } from '../pricing/pricing.module';

@Module({
  imports: [
    PricingModule,
  ],
  controllers: [PortfolioController],
  providers: [
    PortfolioService,
    PortfolioAnalysisService,
    PortfolioMaturityService,
    PortfolioRecommendationService,
  ],
  exports: [
    PortfolioService,
    PortfolioAnalysisService,   // ✅ ADD
    PortfolioMaturityService,   // ✅ ADD
  ],
})
export class PortfolioModule {}



import { Module } from '@nestjs/common';
import { PortfolioController } from './portfolio.controller';
import { PortfolioService } from './portfolio.service';
import { PortfolioAnalysisService } from './portfolio-analysis.service';
import { PricingModule } from '../pricing/pricing.module';
import { PortfolioMaturityService } from './portfolio-maturity.service';
import { PortfolioRecommendationService } from './portfolio-recommendation.service';

@Module({
  imports: [PricingModule],
  controllers: [PortfolioController],
  providers: [
    PortfolioService,
    PortfolioAnalysisService,
    PortfolioMaturityService,
    PortfolioRecommendationService, // ✅
  ],
})
export class PortfolioModule {}

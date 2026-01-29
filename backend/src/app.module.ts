import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { PortfolioModule } from './portfolio/portfolio.module';
import { PricingModule } from './pricing/pricing.module';

@Module({
  imports: [
    AuthModule,
    PortfolioModule,
    PricingModule, // ✅ REQUIRED
  ],
})
export class AppModule {}


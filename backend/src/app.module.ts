import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { PortfolioModule } from './portfolio/portfolio.module';
import { PricingModule } from './pricing/pricing.module';
import { AccountsModule } from './accounts/accounts.module';
import { IngestionModule } from './ingestion/ingestion.module';
import { NotificationsModule } from './notifications/notifications.module';
import { IntegrationsModule } from './integrations/integrations.module';

@Module({
  imports: [
    AuthModule,
    PortfolioModule,
    PricingModule, // ✅ REQUIRED (unchanged)
    AccountsModule, // ✅ V2
    IngestionModule, // ✅ V2
   NotificationsModule, // ✅ V2.2
  IntegrationsModule, // ✅ V3.3
  ],
})
export class AppModule {}



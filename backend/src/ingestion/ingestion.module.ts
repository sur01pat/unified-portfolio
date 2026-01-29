import { Module } from '@nestjs/common';
import { AssetIngestionService } from './asset-ingestion.service';
import { IngestionController } from './ingestion.controller';
import { PortfolioModule } from '../portfolio/portfolio.module';

@Module({
  imports: [
    PortfolioModule, // ✅ REQUIRED
  ],
  providers: [AssetIngestionService],
  controllers: [IngestionController],
})
export class IngestionModule {}


// src/portfolio/portfolio.controller.ts

import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { PortfolioService } from './portfolio.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CreateAssetDto } from './dto/create-asset.dto';
import { PortfolioAnalysisService } from './portfolio-analysis.service';
import { PortfolioMaturityService } from './portfolio-maturity.service';
import { PortfolioRecommendationService } from './portfolio-recommendation.service';

@ApiTags('Portfolio')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('portfolio')
export class PortfolioController {
  constructor(
  private readonly portfolioService: PortfolioService,
  private readonly analysisService: PortfolioAnalysisService,
  private readonly maturityService: PortfolioMaturityService,
  private readonly recommendationService: PortfolioRecommendationService,
) {}




  // ✅ ADD ASSET (THIS FIXES 404)
  @Post('assets')
  addAsset(@Req() req, @Body() dto: CreateAssetDto) {
    return this.portfolioService.create(req.user.sub, dto);
  }

  // ✅ LIST ASSETS
  @Get('assets')
  getAssets(@Req() req) {
    return this.portfolioService.findAll(req.user.sub);
  }

  // ✅ PORTFOLIO SUMMARY
  @Get('summary')
    async getSummary(@Req() req) {
        return await this.portfolioService.getSummary(
    req.user.sub,
  );
}


  // (optional, future)
  @Delete('assets/:id')
  deleteAsset(@Req() req, @Param('id') id: string) {
    this.portfolioService.delete(req.user.sub, id);
    return { success: true };
  }
  @Get('analysis')
getAnalysis(@Req() req) {
  return this.analysisService.analyze(req.user.sub);
}
//--seed data
@Post('seed')
seed(@Req() req) {
  return this.portfolioService.seedSyntheticData(
    req.user.sub,
  );
}
@Get('maturities')
getMaturities(@Req() req) {
  return this.maturityService.getMaturities(req.user.sub);
}
@Get('recommendations')
getRecommendations(@Req() req) {
  return this.recommendationService.getRecommendations(
    req.user.sub,
  );
}


}


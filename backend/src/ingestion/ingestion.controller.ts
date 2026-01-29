import { Controller, Post, Req, UseGuards } from '@nestjs/common';
import { AssetIngestionService } from './asset-ingestion.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Ingestion (V2)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v2/ingest')
export class IngestionController {
  constructor(
    private readonly ingestionService: AssetIngestionService,
  ) {}

  @Post('broker')
  ingestBroker(@Req() req) {
    return this.ingestionService.ingestFromBroker(
      req.user.sub, // ✅ now defined
    );
  }

  @Post('bank')
  ingestBank(@Req() req) {
    return this.ingestionService.ingestFromBank(
      req.user.sub, // ✅ now defined
    );
  }
}

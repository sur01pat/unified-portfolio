import {
  Controller,
  Get,
  Req,
  UseGuards,
  Query,
} from '@nestjs/common';
import { IntegrationService } from './integration.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('Integrations (V3)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v3/integrations')
export class IntegrationController {
  constructor(
    private readonly integrationService: IntegrationService,
  ) {}

  /**
   * Temporary sync endpoint (mock AA / broker)
   * Will later enforce consent
   */
  @Get('sync')
  async sync(
    @Req() req,
    @Query('providerId') providerId: string,
  ) {
    return this.integrationService.sync(
      req.user.sub,
      providerId,
    );
  }
}

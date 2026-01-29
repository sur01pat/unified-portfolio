import {
  Controller,
  Get,
  Req,
  UseGuards,
} from '@nestjs/common';
import { SyncJobService } from './sync-job.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('Integrations – Sync Jobs (V3)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v3/sync-jobs')
export class SyncJobController {
  constructor(
    private readonly syncJobService: SyncJobService,
  ) {}

  @Get()
  list(@Req() req) {
    return this.syncJobService.list(req.user.sub);
  }
}

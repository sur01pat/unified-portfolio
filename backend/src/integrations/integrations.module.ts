import { Module } from '@nestjs/common';
import { IntegrationService } from './integration.service';
import { ConsentService } from './consent.service';
import { ConsentController } from './consent.controller';
import { IntegrationController } from './integration.controller';
import { SyncJobService } from './sync-job.service';
import { SyncJobController } from './sync-job.controller';

@Module({
  providers: [
    IntegrationService,
    ConsentService,
    SyncJobService,
  ],
  controllers: [
    ConsentController,
    IntegrationController,
    SyncJobController,
  ],
})
export class IntegrationsModule {}



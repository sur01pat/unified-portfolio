import {
  Injectable,
  ForbiddenException,
} from '@nestjs/common';
import { MockAAAdapter } from './adapters/mock-aa.adapter';
import { ConsentService } from './consent.service';
import { SyncJobService } from './sync-job.service';

@Injectable()
export class IntegrationService {
  private adapters = [new MockAAAdapter()];

  constructor(
    private readonly consentService: ConsentService,
    private readonly syncJobService: SyncJobService,
  ) {}

  getAdapter(providerId: string) {
    return this.adapters.find(
      a => a.providerId() === providerId,
    );
  }

  async sync(userId: string, providerId: string) {
    // 🔐 Consent enforcement
    if (
      !this.consentService.hasActiveConsent(
        userId,
        providerId,
      )
    ) {
      throw new ForbiddenException(
        'No active consent for this provider',
      );
    }

    const adapter = this.getAdapter(providerId);
    if (!adapter) {
      throw new ForbiddenException(
        'Integration provider not supported',
      );
    }

    // 🧾 Start sync job
    const job = this.syncJobService.start(
      userId,
      providerId,
    );

    try {
      const accounts =
        await adapter.fetchAccounts(userId);

      const fds = adapter.fetchFixedDeposits
        ? await adapter.fetchFixedDeposits(userId)
        : [];

      this.syncJobService.succeed(job.id);
      return { jobId: job.id, accounts, fds };
    } catch (e: any) {
      this.syncJobService.fail(
        job.id,
        e.message || 'Unknown error',
      );
      throw e;
    }
  }
}

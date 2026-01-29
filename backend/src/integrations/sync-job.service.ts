import { Injectable } from '@nestjs/common';
import { v4 as uuid } from 'uuid';
import {
  SyncJob,
  SyncStatus,
} from './sync-job.entity';

@Injectable()
export class SyncJobService {
  private jobs: SyncJob[] = [];

  start(
    userId: string,
    providerId: string,
  ): SyncJob {
    const job: SyncJob = {
      id: uuid(),
      userId,
      providerId,
      startedAt: new Date(),
      status: SyncStatus.PARTIAL,
    };

    this.jobs.push(job);
    return job;
  }

  succeed(jobId: string) {
    const job = this.jobs.find(j => j.id === jobId);
    if (!job) return;

    job.status = SyncStatus.SUCCESS;
    job.finishedAt = new Date();
  }

  fail(jobId: string, error: string) {
    const job = this.jobs.find(j => j.id === jobId);
    if (!job) return;

    job.status = SyncStatus.FAILED;
    job.errorMessage = error;
    job.finishedAt = new Date();
  }

  list(userId: string): SyncJob[] {
    return this.jobs.filter(j => j.userId === userId);
  }
}

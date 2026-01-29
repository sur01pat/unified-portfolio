export enum SyncStatus {
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
  PARTIAL = 'PARTIAL',
}

export class SyncJob {
  id: string;
  userId: string;
  providerId: string;

  startedAt: Date;
  finishedAt?: Date;

  status: SyncStatus;
  errorMessage?: string;
}

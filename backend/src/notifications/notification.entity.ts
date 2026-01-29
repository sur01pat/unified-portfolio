export type NotificationType =
  | 'FD_MATURITY'
  | 'SYNC_FAILED'
  | 'RISK_ALERT'
  | 'ENGAGEMENT';

export class Notification {
  id: string;
  userId: string;

  type: NotificationType;
  title: string;
  message: string;
  severity: 'INFO' | 'WARNING' | 'CRITICAL';

  createdAt: Date;
  read: boolean;
}

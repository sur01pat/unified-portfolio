import { InstitutionType } from '../institutions/institution.entity';

export class Account {
  id: string;
  userId: string;
  institutionId: string;
  institutionType: InstitutionType;

  accountName: string;
  accountNumberMasked: string;

  lastSyncedAt?: Date;
  status: 'ACTIVE' | 'ERROR' | 'DISCONNECTED';
}

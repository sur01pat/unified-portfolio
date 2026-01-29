export enum InstitutionType {
  BANK = 'BANK',
  BROKER = 'BROKER',
}

export class Institution {
  id: string;
  name: string;
  type: InstitutionType;
  country: string;
}

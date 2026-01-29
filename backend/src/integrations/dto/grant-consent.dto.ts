import { IsArray, IsOptional, IsString } from 'class-validator';

export class GrantConsentDto {
  @IsString()
  providerId: string;

  @IsArray()
  scopes: string[];

  @IsOptional()
  ttlDays?: number;
}

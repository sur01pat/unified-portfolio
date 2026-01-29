import { AssetType } from '../asset.entity';


export class CreateAssetDto {
type: AssetType;
name: string;
symbol?: string;
quantity: number;
purchasePrice: number;
currency: string;
sector?: string;
country?: string;
platform?: string;
}
import { Controller, Get } from '@nestjs/common';
import { PricingService } from './pricing.service';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('Pricing')
@Controller('prices')
export class PricingController {
  constructor(private readonly pricingService: PricingService) {}

  @Get()
  getPrices() {
    return this.pricingService.getPrices();
  }
}

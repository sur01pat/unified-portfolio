import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Req,
  UseGuards,
  BadRequestException,
} from '@nestjs/common';
import { ConsentService } from './consent.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { GrantConsentDto } from './dto/grant-consent.dto';

@ApiTags('Integrations – Consent (V3)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v3/consents')
export class ConsentController {
  constructor(
    private readonly consentService: ConsentService,
  ) {}

  @Post('grant')
  grant(
    @Req() req,
    @Body() body: GrantConsentDto,
  ) {
    if (!body || !body.providerId) {
      throw new BadRequestException(
        'providerId and scopes are required',
      );
    }

    return this.consentService.grant(
      req.user.sub,
      body.providerId,
      body.scopes,
      body.ttlDays,
    );
  }

  @Get()
  list(@Req() req) {
    return this.consentService.list(req.user.sub);
  }

  @Post(':id/revoke')
  revoke(@Req() req, @Param('id') id: string) {
    return this.consentService.revoke(
      req.user.sub,
      id,
    );
  }
}


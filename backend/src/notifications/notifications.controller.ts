import {
  Controller,
  Get,
  Post,
  Param,
  Req,
  UseGuards,
} from '@nestjs/common';
import { NotificationService } from './notification.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('Notifications (V2)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v2/notifications')
export class NotificationsController {
  constructor(
    private readonly notificationService: NotificationService,
  ) {}

  @Get()
  getAll(@Req() req) {
    return this.notificationService.generate(
      req.user.sub,
    );
  }

  @Post(':id/read')
  markRead(@Req() req, @Param('id') id: string) {
    this.notificationService.markRead(
      req.user.sub,
      id,
    );
    return { ok: true };
  }
}

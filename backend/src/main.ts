import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // 🔹 Swagger configuration
  const config = new DocumentBuilder()
    .setTitle('Unified Portfolio API')
    .setDescription('Authentication & Portfolio APIs')
    .setVersion('1.0')
    .addBearerAuth() // for future JWT-secured APIs
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(3000);
}
bootstrap();

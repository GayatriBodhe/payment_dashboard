import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
// Correct the path to the LoginDto module
import { LoginDto } from '../common/dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }
}
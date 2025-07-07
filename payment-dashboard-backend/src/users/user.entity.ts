import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('users') // Explicitly set table name to 'users'
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  username: string;

  @Column()
  password: string;

  @Column({ enum: ['admin', 'viewer'] })
  role: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;
}
const { describe, it, before, after } = require('node:test');
const assert = require('node:assert/strict');
const mongoose = require('mongoose');
const request = require('supertest');

process.env.JWT_SECRET = 'test-secret';
process.env.JWT_EXPIRES_IN = '1h';

const app = require('../app');
const seedPrograms = require('../seed/seedPrograms');

const mongoUri = process.env.MONGODB_TEST_URI || 'mongodb://127.0.0.1:27017/campusflow_test';
let token;
const email = `alex.${Date.now()}@test.com`;

describe('CampusFlow API', () => {
  before(async () => {
    await mongoose.connect(mongoUri);
    await mongoose.connection.dropDatabase();
    await seedPrograms();
  });

  after(async () => {
    await mongoose.connection.dropDatabase();
    await mongoose.disconnect();
  });

  it('reports health', async () => {
    const res = await request(app).get('/health');
    assert.equal(res.status, 200);
    assert.equal(res.body.status, 'ok');
  });

  it('signs up a user', async () => {
    const res = await request(app).post('/auth/signup').send({
      name: 'Alex Learner',
      email,
      password: 'secret12',
    });
    assert.equal(res.status, 201);
    assert.equal(res.body.user.email, email);
    assert.equal(res.body.user.password, undefined);
  });

  it('rejects duplicate signup', async () => {
    const res = await request(app).post('/auth/signup').send({
      name: 'Alex Learner',
      email,
      password: 'secret12',
    });
    assert.equal(res.status, 409);
  });

  it('rejects invalid login', async () => {
    const res = await request(app).post('/auth/login').send({
      email,
      password: 'wrong-password',
    });
    assert.equal(res.status, 401);
  });

  it('logs in and returns a token', async () => {
    const res = await request(app).post('/auth/login').send({
      email,
      password: 'secret12',
    });
    assert.equal(res.status, 200);
    assert.ok(res.body.token);
    token = res.body.token;
  });

  it('returns the current user', async () => {
    const res = await request(app).get('/auth/me').set('Authorization', `Bearer ${token}`);
    assert.equal(res.status, 200);
    assert.equal(res.body.user.email, email);
  });

  it('lists programs in the Flutter shape', async () => {
    const res = await request(app).get('/programs');
    assert.equal(res.status, 200);
    assert.ok(Array.isArray(res.body));
    const design = res.body.find((p) => p.id === 'p1');
    assert.equal(design.title, 'Design Thinking Workshop');
    assert.equal(design.category, 'Workshop');
    assert.ok(Number.isInteger(design.capacity));
  });

  it('registers for a program once', async () => {
    const first = await request(app)
      .post('/programs/p1/register')
      .set('Authorization', `Bearer ${token}`);
    assert.equal(first.status, 201);
    assert.equal(first.body.message, 'Registration confirmed');

    const second = await request(app)
      .post('/programs/p1/register')
      .set('Authorization', `Bearer ${token}`);
    assert.equal(second.status, 409);
  });

  it('lists registrations', async () => {
    const res = await request(app)
      .get('/registrations')
      .set('Authorization', `Bearer ${token}`);
    assert.equal(res.status, 200);
    assert.equal(res.body[0].programId, 'p1');
    assert.equal(res.body[0].program.title, 'Design Thinking Workshop');
  });

  it('accepts feedback', async () => {
    const res = await request(app)
      .post('/programs/p1/feedback')
      .set('Authorization', `Bearer ${token}`)
      .send({
        rating: 5,
        category: 'Content',
        email,
        comment: 'Clear, practical, and well paced.',
      });
    assert.equal(res.status, 201);
  });

  it('rejects short feedback', async () => {
    const res = await request(app)
      .post('/programs/p1/feedback')
      .set('Authorization', `Bearer ${token}`)
      .send({
        rating: 4,
        category: 'Content',
        email,
        comment: 'too short',
      });
    assert.equal(res.status, 400);
  });

  it('lists and marks notifications', async () => {
    const list = await request(app)
      .get('/notifications')
      .set('Authorization', `Bearer ${token}`);
    assert.equal(list.status, 200);
    assert.ok(list.body.unreadCount >= 1);
    const id = list.body.notifications[0].id;

    const read = await request(app)
      .patch(`/notifications/${id}/read`)
      .set('Authorization', `Bearer ${token}`);
    assert.equal(read.status, 200);
    assert.equal(read.body.read, true);

    const all = await request(app)
      .patch('/notifications/read-all')
      .set('Authorization', `Bearer ${token}`);
    assert.equal(all.status, 200);
    assert.equal(all.body.unreadCount, 0);
  });
});

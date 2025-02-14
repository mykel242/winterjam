// tests/api.test.js
const request = require("supertest");
const app = require("../server");
const apiRouter = require("../routes/api");
const pool = apiRouter.pool;

describe("API Endpoints", () => {
  const testUser = { id: 99, name: "Test User", email: "testuser@example.com" };

  // Test the endpoints list
  it("should return the endpoints list on GET /api", async () => {
    const res = await request(app).get("/api").expect(200);
    expect(res.body).toHaveProperty("endpoints");
    expect(Array.isArray(res.body.endpoints)).toBe(true);
  });

  // Test GET /api/endpoints (should return the same as /api)
  it("should return the endpoints list on GET /api/endpoints", async () => {
    const res = await request(app).get("/api/endpoints").expect(200);
    expect(res.body).toHaveProperty("endpoints");
    expect(Array.isArray(res.body.endpoints)).toBe(true);
  });

  // Test GET /api/users when no users exist or when data is present.
  // For a proper test, you might want to seed your database or use a mock.
  it("should retrieve users on GET /api/users", async () => {
    const res = await request(app).get("/api/users").expect(200);
    // Assuming the endpoint returns an array.
    expect(Array.isArray(res.body)).toBe(true);
  });

  // Test POST /api/users to create a new user.
  it("should create a new user on POST /api/users", async () => {
    const res = await request(app)
      .post("/api/users")
      .send(testUser)
      .set("Content-Type", "application/json")
      .expect(201);

    expect(res.body).toHaveProperty("id", testUser.id);
    expect(res.body).toHaveProperty("name", testUser.name);
    expect(res.body).toHaveProperty("email", testUser.email);
  });

  // Cleanup: Remove the test user after each test run
  afterEach(async () => {
    // We can send a DELETE request to remove the test user.
    // If the test user doesn't exist (e.g., if the test failed before creation),
    // this might return a 404, which is acceptable for cleanup.
    await request(app).delete(`/api/users/${testUser.id}`);
  });

  // You can add more tests for PUT and DELETE endpoints as needed.
});

afterAll(async () => {
  await pool.end();
});

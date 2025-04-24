require('dotenv').config(); // Load environment variables from .env file
const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
const port = 3000; 
const uri = process.env.MONGODB_URI; 
if (!uri) {
  console.error('MONGODB_URI environment variable is not set!');
  process.exit(1); // Exit with an error code
}
const client = new MongoClient(uri);
app.use(cors());
app.use(express.json()); // Add this line to parse JSON request bodies

async function connectToDatabase() {
  try {
    await client.connect();
    console.log("Connected successfully to MongoDB");
  } catch (err) { 
    console.error("Error connecting to MongoDB:", err);
    throw err;
  } 
} 

app.post('/storeResult', async (req, res) => {
  try {
    await connectToDatabase();
    const db = client.db("quiz_app");
    const collection = db.collection("results");
    const result = await collection.insertOne(req.body);
    res.status(201).json(result);
  } catch (error) {
    console.error("Error storing result:", error);
    res.status(500).json({ error: "Failed to store result" });
  } finally {
      await client.close();
  }
});

app.get('/getQuestions', async (req, res) => {
  try {
      await connectToDatabase();
      const db = client.db("quiz_app");
      const collection = db.collection("questions");
      const questions = await collection.find().toArray();
      res.json(questions);
  } catch (error) {
      console.error("Error fetching questions:", error);
      res.status(500).json({ error: "Failed to fetch questions" });
  } finally {
      await client.close();
  }
});

app.listen(port, () => console.log(`Backend running on port ${port}`));
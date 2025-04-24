const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json()); 
const uri = 'mongodb+srv://hboubaker59:aSMsAY9OApz0hjcM@apps.tkxquq8.mongodb.net/quiz_app?retryWrites=true&w=majority&tls=true&tlsAllowInvalidCertificates=true';

const client = new MongoClient(uri);

async function run() {
async function connectToDatabase() {
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    
  } catch (err) {
    console.error('Error connecting to MongoDB', err);
    process.exit(1);
    
    
  }
}

connectToDatabase();

app.get('/questions', async (req, res) => {
  try {
    const db = client.db('quiz_app');
    const questions = await db.collection('questions').find({}).toArray();
    res.json(questions);
  } catch (err) {
    console.error('Error fetching questions', err);
    res.status(500).json({ message: 'Error fetching questions' });
  }
});

app.post('/results', async (req, res) => {
  try {
    const db = client.db('quiz_app');
    const result = req.body;
    await db.collection('results').insertOne(result); 
    res.json({ message: 'Result stored successfully' }); 
  } catch (err) {
    console.error('Error storing result', err);
    res.status(500).json({ message: 'Error storing result' });
  }
});


  app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
  });
  
}
run().catch(console.dir);

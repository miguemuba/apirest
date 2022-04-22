const express = require('express');

// teamsRoutes is an instance of the express router.
// The router will be added as a middleware and will take control of requests starting with path /api/team.
const teamsRoutes = express.Router();

// This will help us connect to the database
const dbo = require('../db/conn');

// This section will help you get a list of all the teams.
teamsRoutes.route('/api/team').get(async function (req, res) {
  const dbConnect = dbo.getDb();
  
  dbConnect
    .collection('equipos')
    .find({})
    .project({"@nombre": 1, "_id": 0})
    .toArray(function (err, result) {
      if (err) {
        res.status(400).send('Error fetching listings!');
      } else {
        res.json(result);
      }
    });
});


module.exports = teamsRoutes;

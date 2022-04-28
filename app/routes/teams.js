const express = require('express');

// teamsRoutes is an instance of the express router.
// The router will be added as a middleware and will take control of requests starting with path /api/team.
const teamsRoutes = express.Router();

// This will help us connect to the database
const dbo = require('../db/conn');
let page = 0;
let limit = 0;
// This section will help you get a list of all the teams.
teamsRoutes.route('/api/team').get(async function (req, res) {
  const dbConnect = dbo.getDb();
  if (!req.query.page || !req.query.limit) {
     page = 0;
     limit = 0;
    
  } else {
    page = parseInt(req.query.page);
    limit = parseInt(req.query.limit);
  }
  const skipIndex = (page - 1) * limit;
  dbConnect
    .collection('equipos')
    .find({})
    .project({"@nombre": 1, "_id": 0})
    .sort()
    .limit(limit)
    .skip(skipIndex)
    .toArray(function (err, result) {
      if (err) {
        res.status(400).send('Error fetching listings!');
      } else {
        res.json(result);
      }
    });
});


module.exports = teamsRoutes;

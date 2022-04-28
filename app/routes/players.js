const express = require('express');

// playersRoutes is an instance of the express router.
// The router will be added as a middleware and will take control of requests starting with path /api/teams/:id/players.
const playersRoutes = express.Router();

// This will help connect to the database
const dbo = require('../db/conn');
const verify = require('../jwt/verifyToken.js')
// This section will help get a list of all the team's (:id) players
playersRoutes.route('/api/teams/:id/players').get( verify, async function (req, res) {
  const dbConnect = dbo.getDb();
  
  dbConnect
    .collection('equipos')
    .find({ "@id": req.params.id })
    .project({ "jugadores.jugador.nombre": 1, "_id": 0, "@nombre": 1 })
    .toArray(function (err, result) {
      if (err) {
        res.status(400).send('Error fetching listings!');
      } else {
        res.json(result);
      }
    });
});


module.exports = playersRoutes;

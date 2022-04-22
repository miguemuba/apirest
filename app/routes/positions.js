const express = require('express');

// positionsRoutes is an instance of the express router.
// The router will be added as a middleware and will take control of requests starting with path /api/teams/players/:position.
const positionsRoutes = express.Router();

// This will help connect to the database
const dbo = require('../db/conn');

// This section will help get a list of all the players that have the predifined position by :position.
positionsRoutes.route('/api/teams/players/:position').get(async function (req, res) {
  const dbConnect = dbo.getDb();

  dbConnect
    .collection('jugadores')
    .aggregate(
        [  
            {
                $lookup:
                   {
                      from: "equipos",
                      localField: "@id",
                      foreignField: "jugadores.jugador.@id",
                      as: "equipo"
                  }
                  
             },
             {
                $match: { "rol.#text": req.params.position }
            },
             {
                $group: {
                    _id : "$equipo.@nombre",
                    jugadores: { $push: "$$ROOT"}
                }
            },
            {
                $project: { "_id": 1, "jugadores.nombre": 1, "jugadores.apellido": 1, "jugadores.rol.#text": 1}
            }
            
])
    .toArray(function (err, result) {
        if (err) {
          res.status(400).send('Error fetching listings!');
        } else {
          res.json(result);
        }
      });

});


module.exports = positionsRoutes;

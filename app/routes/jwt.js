const jwt = require('jsonwebtoken');
const express = require('express');
const jwtRoutes = express.Router();

// This section perform login returning a token for the request authentication.
jwtRoutes.route('/api/login').post(async function (req, res) {
    const user = {
        id: 1,
        nombre : "Henry",
        email: "henry@email.com"
    }
   
    jwt.sign({user}, 'secretkey', {expiresIn: '32s'}, (err, token) => {
        res.json({
            token
        });
    });
  });

module.exports = jwtRoutes;
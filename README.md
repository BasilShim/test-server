# API:
 - POST /kv body: {key: "test", "value": {SOME ARBITRARY JSON}} 
 - PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
 - GET kv/{id} 
 - DELETE kv/{id}
 
 -----------------------------------------------------------------

 - POST  returns 409, if key already exists, 
 - POST, PUT return 400, if body is invalid (incorrect)
 - PUT, GET, DELETE return 404, if key does not exist

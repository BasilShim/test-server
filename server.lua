local json = require('json')
local localPath = '/kv'
local longPath = '/kv/:key'
local RequestMethods = require('request_methods')

-- Configuration

box.cfg{
  log_format = 'plain',
  background = true,
  log_level = 6,
  log = 'journal.log',
  pid_file = 'server.pid'
}
box.once('init', function()
    box.schema.create_space('database')
    box.space.database:create_index(
        "primary", {type = 'hash', parts = {1, 'string'}}
    )
    end
)

-- Server

local port = 7890
local httpServer = require('http.server').new(nil, port)

httpServer:route({path = localPath, method = "POST"   }, RequestMethods.POSTMethod)
httpServer:route({path = longPath, method = "PUT"    }, RequestMethods.PUTMethod)
httpServer:route({path = longPath, method = "GET"    }, RequestMethods.GETMethod)
httpServer:route({path = longPath, method = "DELETE" }, RequestMethods.DELETEMethod)
httpServer:start()

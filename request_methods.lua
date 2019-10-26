local json = require('json')

local request_methods = {}

request_methods.POSTMethod = function (request)
    local body = request:json()
    local key = body["key"]
    local value = body["value"]

    if type(key) ~= "string" or not value then
        return {status = 400}
    end

    if pcall(box.space.database.insert, box.space.database, {key, value}) then
        return {status = 200}
    else
        return {status = 409}
    end
end

request_methods.PUTMethod = function (request)
    local body = request:json()
    local key = request:stash('key')
    local value = body["value"]

    if not value then
        return {status = 400}
    end

    if box.space.database:update({key}, {{'=', 2, value}}) then
        return {status = 200}
    else
        return {status = 404}
    end
end

request_methods.GETMethod = function (request)
    local key = request:stash('key')

    local result = box.space.database:get(key)
    if result then
        return {status = 200, body = json.encode(result[2])}
    else
        return {status = 404}
    end
end

request_methods.DELETEMethod = function (request)
    local key = request:stash('key')

    if box.space.database:delete(key) then
        return {status = 200}
    else
        return {status = 404}
    end
end

return request_methods

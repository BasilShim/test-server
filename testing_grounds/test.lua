local httpClient = require("http.client")
local json = require("json")
local tap = require("tap")

local url = "http://localhost:7890/kv"
local longURL = "http://localhost:7890/kv/"

local test = tap.test("HTTP server test")
test:plan(10)

local testSubjects = {{ key = "1", value = 1 },
  {key = "2", value = "2" },
  {key = 3},
  {key = "4"}
}

local otherSubjects = {{value = "231"},
  {value = 231}
}

for i = 1, #testSubjects, 1 do
  httpClient.delete(longURL..testSubjects[i].key)
end

function TestPOST ()
  local testName = "Successful POST"
  test:is(httpClient.post(url, json.encode(testSubjects[1])).status, 200, testName)

  testName = "Already exists"
  test:is(httpClient.post(url, json.encode(testSubjects[1])).status, 409, testName)

  testName = "Invalid body"
  test:is(httpClient.post(url, json.encode(testSubjects[3])).status, 400, testName)
end

function TestPUT ()
  local testName = "Successful PUT"

  test:is(httpClient.put(longURL..testSubjects[1].key, json.encode(otherSubjects[1])).status, 200, testName)

  testName = "Invalid body"
  test:is(httpClient.put(longURL..testSubjects[1].key, json.encode(testSubjects[3])).status, 400, testName)

  testName = "Invalid key"
  test:is(httpClient.put(longURL..testSubjects[4].key, json.encode(otherSubjects[2])).status, 404, testName)
end

function TestGET ()
  local testName = "Successful GET"

  test:is(httpClient.get(longURL..testSubjects[1].key).status, 200, testName)

  testName = "Invalid key"
  test:is(httpClient.get(longURL..testSubjects[3].key).status, 404, testName)
end

function TestDELETE ()
  local testName = "Successful DELETE"

  test:is(httpClient.delete(longURL..testSubjects[1].key).status, 200, testName)

  testName = "Invalid key"
  test:is(httpClient.delete(longURL..testSubjects[3].key).status, 404, testName)
end

function main ()
  TestPOST()
  TestPUT()
  TestGET()
  TestDELETE()
end

main()
test:check()

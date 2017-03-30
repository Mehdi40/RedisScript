--
-- EVAL zAddAll Dev.Models.SC.ListItems.listitems_154795.List.array msgpack(array(ids))
--

--
-- sortedSetKey - The string name of the sorted set
-- payload - The msgpack of the array containings the IDs we want to add to the sorted set
-- data - The payload unpacked
--

local sortedSetKey, payload = KEYS[1], KEYS[2]
local data = nil

data = cjson.decode(payload)

if type(data) == "table" then
    for key, value in pairs(data) do
        redis.call('zadd', sortedSetKey, key, value)
    end
end
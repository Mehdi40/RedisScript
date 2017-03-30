--
-- EVAL zEdit.lua TestScript change 3 6 / Takes the third item, place it at the sixth place and edit the position of items between them
-- EVAL TestScript add 3 / Add an item to the third place and modify all items'position after it
-- EVAL TestScript del 3 / Delete the third item and modify all items'position after it
--

--
-- sortedSetKey - The string name of the sorted set
-- action - What we want to do
-- member - The item we will be editing
-- place - The place we want the item to go / Only in 'change' mode
-- data - The data we want to add / Only in 'add' mode
--
-- increment - Whether we increment or decrement the items secondly modified
-- incrementMember - Basically the future place of the member / Only in 'change' mode
-- reverse - Whether we reverse the increment or not / Only in 'change' mode
--
-- numberOfElements = The number of elements in the sorted set
--
-- sortedSet = The sorted set
--

-- Set the main variables
local sortedSetKey, action, member, place, data = KEYS[1], KEYS[2], tonumber(KEYS[3]), -1, false

-- Set the var place, that corresponds to the place we want to add/change/del the item
-- If the var is equals to -1, that means the var is nil
if action ~= "change" then
    place = -1
else
    place = tonumber(KEYS[4])
end

-- Set the secondary variables
local increment, incrementMember, reverse  = 0, place - member, false
local numberOfElements = redis.call('zcard', sortedSetKey)
local sortedSet = redis.call('zrangebyscore', sortedSetKey, 0, numberOfElements)


-- Set the var increment, that corresponds to whether we increment or decrement items
if member > place then
    if action == "del" then
        increment = -1
    else
        increment = 1
    end
else
    increment = -1
    reverse = true
end

-- Set the var data, that corresponds to the data we will be adding to the sorted set
if action == "add" then
    data = KEYS[4]
end

-- Main loop
for key, value in pairs(sortedSet) do
    if place == -1 then
        if action == "add" then
            if key >= member then
                redis.call('zincrby', sortedSetKey, increment, value)
            end
        else
            if key >= member then
                if key == member then
                    redis.call('ZREM', sortedSetKey, value)
                else
                    redis.call('ZINCRBY', sortedSetKey, increment, value)
                end
            end
        end
    else
        if key == member then
            redis.call('ZINCRBY', sortedSetKey, incrementMember, value)
        end
        if reverse == true then
            if member < key and key <= place then
                redis.call('ZINCRBY', sortedSetKey, increment, value)
            end
        else
            if member > key and key >= place then
                redis.call('ZINCRBY', sortedSetKey, increment, value)
            end
        end
    end
end

-- Add the items if we have to, not to be trapped by the loop*
if action == "add" then
    redis.call('ZADD', sortedSetKey, member, data)
end

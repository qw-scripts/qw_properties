local MySQL = MySQL
local db = {}

local CREATE_NEW_PROPERTY = "INSERT INTO properties (name, price, x, y, z, shell) VALUES (?, ?, ?, ?, ?, ?)"

function db.createProperty(name, price, x, y, z, shell)
    return MySQL.query.await(CREATE_NEW_PROPERTY, { name, price, x, y, z, shell })
end

function db.getProperties()
    return MySQL.query.await("SELECT * FROM properties")
end

return db

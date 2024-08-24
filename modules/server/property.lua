local db = lib.load("modules.server.db")
local property = {}

local propertiesCache = {}

function property.getProperties()
    return propertiesCache
end

function property.newProperty(data)
    local pData = {
        name = data.name,
        price = data.price,
        owner = nil,
        position = data.position,
        furniture = data.furniture or {},
        shell = data.shell,
    }

    local newProperty = db.createProperty(
        pData.name, pData.price, pData.position.x, pData.position.y, pData.position.z, pData.shell
    )
    if not newProperty then
        return false
    end

    pData.id = newProperty.insertId
    propertiesCache[pData.id] = pData

    return pData
end

MySQL.ready(function()
    local properties = db.getProperties()

    for i = 1, #properties do
        local propertyData = properties[i]
        propertiesCache[propertyData.id] = {
            id = propertyData.id,
            name = propertyData.name,
            price = propertyData.price,
            owner = propertyData.owner,
            position = vector3(propertyData.x, propertyData.y, propertyData.z),
            furniture = {},
            shell = propertyData.shell,
        }
    end

    lib.print.info("Loaded " .. #properties .. " properties")
end)

return property

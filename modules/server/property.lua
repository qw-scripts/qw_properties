local property = {}

local propertiesCache = {}

function property.getProperties()
    return propertiesCache
end

function property.newProperty(data)
    local pData = {
        id = #propertiesCache + 1,
        name = data.name,
        price = data.price,
        owned = false,
        owner = nil,
        position = data.position,
        furniture = data.furniture or {},
        shell = data.shell,
    }

    propertiesCache[pData.id] = pData

    return pData
end

return property

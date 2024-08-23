local property = lib.load('modules.server.property')

lib.callback.register('properties:server:getCurrentProperties', function()
    return property.getProperties()
end)

lib.callback.register('properties:server:newProperty', function(source, data)
    if not IsPlayerAceAllowed(source, 'command') then
        return false
    end
    return property.newProperty(data)
end)

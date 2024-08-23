local modeler = lib.load('modules.client.modeler')
local property = lib.load('modules.client.property')

RegisterCommand('dev:placement', function(_, args)
    if not modeler.isShowing() then
        modeler.showMenu(true)
    end

    local model = args[1] or 'prop_beach_lilo_01'

    local data = modeler.startPlacement({
        model = model
    })

    if data then
        local pos = data.position
        local rot = data.rotation
        local handle = data.handle

        SetEntityCoords(handle, pos.x, pos.y, pos.z)
        SetEntityRotation(handle, rot.x, rot.y, rot.z)
        FreezeEntityPosition(handle, true)
        SetModelAsNoLongerNeeded(model)
    end
end)

RegisterCommand('decorate', function()
    if not modeler.isShowing() then
        modeler.showMenu(true)
    end
end)

RegisterCommand('properties', function()
    local p = property.getProperties()
    print(json.encode(p, { indent = true }))
end)

RegisterCommand('properties:new', function()
    local data = property.newPropertyCreator()
    if data then
        lib.notify({
            description = 'Property created',
            title = 'Properties',
            type = 'success'
        })
    else
        lib.notify({
            description = 'Property creation failed',
            title = 'Properties',
            type = 'error'
        })
    end
end)

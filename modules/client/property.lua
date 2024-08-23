local config = lib.load('modules.client.config')

local lastCoords = nil
local lastHeading = nil
local currentProperty = nil
local currentExit = nil

local property = {}

local properties = {}

function property.getProperties()
    return lib.callback.await('properties:server:getCurrentProperties', false)
end

function property.newProperty(data)
    return lib.callback.await('properties:server:newProperty', false, data)
end

function property.createPropertyPoint(data, label, cb)
    local point = lib.points.new({
        coords = data.position,
        distance = 1.5,
        property = data,
    })

    function point:onEnter()
        lib.showTextUI(label)
    end

    function point:onExit()
        lib.hideTextUI()
    end

    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            cb()
        end
    end

    return point
end

function property.leaveProperty()
    if not currentProperty then return end

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, lastCoords)
    SetEntityHeading(cache.ped, (lastHeading - 180))

    if DoesEntityExist(currentProperty) then
        DeleteEntity(currentProperty)
        currentProperty = nil
        lastCoords = nil
        lastHeading = nil
    end

    if currentExit then
        currentExit:remove()
        currentExit = nil
    end
    DoScreenFadeIn(1000)
end

function property.enterProperty(data)
    if currentProperty then return end
    if not data.shell then return end

    local propertyData = nil

    for i = 1, #config.shells do
        if config.shells[i].model == data.shell then
            propertyData = config.shells[i]
            break
        end
    end

    if not propertyData then return end

    lib.hideTextUI()
    lastCoords = GetEntityCoords(cache.ped)
    lastHeading = GetEntityHeading(cache.ped)

    local shellCoords = data.position - vector3(0.0, 0.0, 45.0)
    local offset = propertyData.exit
    local model = joaat(data.shell)

    lib.requestModel(model, 1000)

    local object = CreateObject(model, shellCoords.x, shellCoords.y, shellCoords.z, false, true, true)
    FreezeEntityPosition(object, true)

    local offsetCoords = GetOffsetFromEntityInWorldCoords(object, offset.x, offset.y, offset.z)

    currentProperty = object

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, offsetCoords)
    SetEntityHeading(cache.ped, offset.w)

    currentExit = property.createPropertyPoint({
        position = offsetCoords
    }, '[**E**] - Leave Property', function()
        property.leaveProperty()
    end)

    Wait(100)

    DoScreenFadeIn(1000)
end

function property.newPropertyCreator()
    local modelInput = {
        type = 'select',
        label = 'Property Shell',
        required = true,
        searchable = true,
        options = {},
    }

    for i = 1, #config.shells do
        local shell = config.shells[i]
        local option = {
            value = shell.model,
            label = shell.label,
        }
        modelInput.options[i] = option
    end

    local input = lib.inputDialog('New Property', {
        { type = 'input',  label = 'Property Name', required = true, min = 4 },
        { type = 'number', label = 'Price',         required = true, min = 1 },
        modelInput,
    })

    if not input then
        return false
    end

    local name = input[1]
    local price = input[2]
    local shell = input[3]
    local position = GetEntityCoords(cache.ped)
    local furniture = {}

    local data = property.newProperty({
        name = name,
        price = price,
        position = position,
        furniture = furniture,
        shell = shell,
    })

    if data then
        local point = property.createPropertyPoint(data, '[**E**] - Enter Property', function()
            property.enterProperty(data)
        end)
        data.point = point

        properties[data.id] = data
    end

    return data
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(properties) do
            lib.hideTextUI()
            v.point:remove()
        end
    end
end)

return property

local obj = lib.load('modules.client.objects')
local modeler = {}
local showingMenu = false
local spawnedProps = {}
local editingEntity = nil
local startingRotation = nil
local startingPosition = nil
local camera = nil

local IsDisabledControlPressed = IsDisabledControlPressed
local SetCamCoord = SetCamCoord
local SetCamRot = SetCamRot
local GetCamCoord = GetCamCoord
local GetCamRot = GetCamRot

local function freeCam()
    local cameraPosition = GetGameplayCamCoord()
    local cameraRotation = GetGameplayCamRot(2)
    local cameraFov = GetGameplayCamFov()
    local inFrontPlayer = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 1.0, 1.0)
    camera = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', cameraPosition.x, cameraPosition.y, cameraPosition.z,
        cameraRotation.x, cameraRotation.y, cameraRotation.z, cameraFov, true, 2)
    SetCamCoord(camera, inFrontPlayer.x, inFrontPlayer.y, inFrontPlayer.z)
    CreateThread(function()
        local multiplier = 0.1
        while showingMenu do
            cameraPosition = GetCamCoord(camera)
            cameraRotation = GetCamRot(camera, 2)
            local forwardX = -math.sin(math.rad(cameraRotation.z))
            local forwardY = math.cos(math.rad(cameraRotation.z))
            local rightX = math.cos(math.rad(cameraRotation.z))
            local rightY = math.sin(math.rad(cameraRotation.z))
            local upwardZ = math.sin(math.rad(cameraRotation.x))
            if IsDisabledControlPressed(0, 241) then -- Mouse Scroll Up
                multiplier = multiplier + 0.01
            end
            if IsDisabledControlPressed(0, 242) then -- Mouse Scroll Down
                multiplier = multiplier - 0.01
            end
            if multiplier < 0.01 then multiplier = 0.001 end
            if multiplier > 1.0 then multiplier = 1.0 end
            if IsDisabledControlPressed(0, 32) then -- W
                cameraPosition = cameraPosition +
                    vector3(forwardX * multiplier, forwardY * multiplier, upwardZ * multiplier)
            end
            if IsDisabledControlPressed(0, 33) then -- S
                cameraPosition = cameraPosition -
                    vector3(forwardX * multiplier, forwardY * multiplier, upwardZ * multiplier)
            end
            if IsDisabledControlPressed(0, 34) then -- A
                cameraPosition = cameraPosition - vector3(rightX * multiplier, rightY * multiplier, 0)
            end
            if IsDisabledControlPressed(0, 35) then -- D
                cameraPosition = cameraPosition + vector3(rightX * multiplier, rightY * multiplier, 0)
            end
            if IsDisabledControlPressed(0, 36) then -- SHIFT
                cameraPosition = cameraPosition - vector3(0, 0, multiplier)
            end
            if IsDisabledControlPressed(0, 203) then -- CTRL
                cameraPosition = cameraPosition + vector3(0, 0, multiplier)
            end
            cameraRotation = cameraRotation -
                vector3(GetDisabledControlNormal(0, 272) * 5, 0, GetDisabledControlNormal(0, 270) * 5)
            SetCamCoord(camera, cameraPosition.x, cameraPosition.y, cameraPosition.z)
            SetCamRot(camera, math.min(math.max(cameraRotation.x, -89), 89), cameraRotation.y, cameraRotation.z, 2)
            Wait(0)
        end
        DestroyCam(camera, false)
        camera = nil
    end)
    SetPlayerControl(cache.playerId, not showingMenu, 0)
    RenderScriptCams(showingMenu, true, 1000, true, true)
end

function modeler.showMenu(bool)
    if not bool then
        editingEntity = nil

        SendNUIMessage({
            action = "controlModel",
            data = {
                direction = 'translate',
                entity = 0,
                model = ''
            }
        })
    end

    SendNUIMessage({
        action = "toggleMenu",
        data = bool
    })

    SetNuiFocus(bool, bool)
    showingMenu = bool
    freeCam()
end

function modeler.isShowing()
    return showingMenu
end

function modeler.startPlacement(data)
    local model = data.model

    local objectSpawnPos = GetEntityCoords(cache.ped) + GetEntityForwardVector(cache.ped) * 3.0

    if not IsModelInCdimage(model) then
        return false, 'Invalid model'
    end

    lib.requestModel(model, 1000)

    local currentObject = obj.createObjectForPlacement(model, objectSpawnPos)

    SendNUIMessage({
        action = "controlModel",
        data = {
            direction = 'translate',
            entity = currentObject,
            model = model
        }
    })

    spawnedProps[currentObject] = true
    editingEntity = currentObject
    startingPosition = GetEntityCoords(currentObject)
    startingRotation = GetEntityRotation(currentObject)

    local gizmoData = exports.object_gizmo:useGizmo(currentObject)

    return gizmoData, nil
end

function modeler.removePlaced(entityId)
    if spawnedProps[entityId] then
        DeleteEntity(entityId)
        spawnedProps[entityId] = nil
        if editingEntity == entityId then
            editingEntity = nil
        end
    end
end

function modeler.clearPlaced()
    for entityId, _ in pairs(spawnedProps) do
        DeleteEntity(entityId)
        spawnedProps[entityId] = nil
    end
    editingEntity = nil
end

RegisterNuiCallback('setUIHasMouse', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    SetNuiFocusKeepInput(data)
    cb(true)
end)

RegisterNuiCallback('resetRotation', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    SetEntityRotation(editingEntity, startingRotation)
    cb(true)
end)

RegisterNuiCallback('resetPosition', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    SetEntityCoords(editingEntity, startingPosition)
    cb(true)
end)

RegisterNuiCallback('snapToGround', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    exports.object_gizmo:snapToGround(editingEntity)
    cb(true)
end)

RegisterNuiCallback('saveCurrentEdit', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    SetNuiFocusKeepInput(false)
    exports.object_gizmo:stopGizmo()
    editingEntity = nil
    startingPosition = nil
    startingRotation = nil
    cb(true)
end)

RegisterNuiCallback('closeMenu', function(data, cb)
    SetNuiFocusKeepInput(false)
    modeler.showMenu(false)
    cb(true)
end)

RegisterNuiCallback('cancelEdit', function(data, cb)
    if not editingEntity then
        return cb(true)
    end

    SetNuiFocusKeepInput(false)
    exports.object_gizmo:stopGizmo()
    modeler.removePlaced(editingEntity)
    startingPosition = nil
    startingRotation = nil
    cb(true)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        modeler.clearPlaced()
    end
end)

return modeler

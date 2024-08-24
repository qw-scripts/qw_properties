local obj = {}

function obj.createObjectForPlacement(hash, currentCameraLookAt)
    local underPlayer = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.0, -1.0)
    local objectSpawnPos = underPlayer + (GetEntityForwardVector(cache.ped) * 3.0)
    local currentObject = CreateObject(hash, objectSpawnPos.x, objectSpawnPos.y, objectSpawnPos.z, false, true, false)
    SetEntityCoords(currentObject, currentCameraLookAt.x, currentCameraLookAt.y, currentCameraLookAt.z, false, false, false, false)

    return currentObject
end

return obj

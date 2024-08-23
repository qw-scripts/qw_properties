local obj = {}

function obj.createObjectForPlacement(hash, currentCameraLookAt)
    local currentObject = CreateObject(hash, 0.0, 0.0, 0.0, false, true, false)
    SetEntityCoords(currentObject, currentCameraLookAt.x, currentCameraLookAt.y, currentCameraLookAt.z, false, false,
        false, false)

    return currentObject
end

return obj

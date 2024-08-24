local obj = {}

function obj.createObjectForPlacement(hash, currentCameraLookAt)
    local currentObject = CreateObject(hash, currentCameraLookAt.x, currentCameraLookAt.y, currentCameraLookAt.z, false, true, false)
    return currentObject
end

return obj

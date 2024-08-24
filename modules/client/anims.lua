local anims = {}

function anims.unlockAnimation()
    lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
    TaskPlayAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, 1500, 49, 0, false, false, false)
end

return anims

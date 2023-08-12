if SERVER then
    CreateConVar( "mp_kick_player_on_remove", "0", FCVAR_ARCHIVE, "Kicks player on remove." )
end

hook.Add( "CanTool", "Player Remover", function( ply, traceResult, toolName )
    if toolName ~= "remover" or not ply:IsAdmin() then return end

    local entity = traceResult.Entity
    if not IsValid( entity ) or not entity:IsPlayer() then return end

    if SERVER then
        if cvars.Bool( "sv_player_remove_kick", false ) then
            entity:Kick( "You have been removed." )
        else
            entity:KillSilent()
        end

        local effectData = EffectData()
        effectData:SetOrigin( entity:GetPos() )
        effectData:SetEntity( entity )
        util.Effect( "entity_remove", effectData, true, true )
    end

    local weapon = ply:GetActiveWeapon()
    if IsValid( weapon ) then
        weapon:DoShootEffect( traceResult.HitPos, traceResult.HitNormal, traceResult.Entity, traceResult.PhysicsBone, IsFirstTimePredicted() )
    end

    return false
end )
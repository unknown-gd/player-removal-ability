if SERVER then
    CreateConVar( "sv_player_remove_kick", "0", FCVAR_ARCHIVE, "Kick players on remove." )
end

hook.Add( "CanTool", "Player Remover", function( ply, tr, toolname )
    if toolname == "remover" and ply:IsAdmin() then
        local ent = tr.Entity
        if IsValid( ent ) and ent:IsPlayer() then
            if SERVER then
                if cvars.Bool( "sv_player_remove_kick", false ) then
                    ent:Kick( "You have been removed." )
                else
                    ent:KillSilent()
                end

                local fx = EffectData()
                fx:SetOrigin( ent:GetPos() )
                fx:SetEntity( ent )
                util.Effect( "entity_remove", fx, true, true )
            end

            local wep = ply:GetActiveWeapon()
            if IsValid( wep ) then
                wep:DoShootEffect( tr.HitPos, tr.HitNormal, tr.Entity, tr.PhysicsBone, IsFirstTimePredicted() )
            end

            return false
        end
    end
end )
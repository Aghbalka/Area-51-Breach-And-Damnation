local VFXModule = {}

VFXModule.VFX = {
	Screenshake = function(Plr, Intensity, Duration) end,
}

function VFXModule.PlayVFX(Plr, VFXName, Intensity, Duration)
	if VFXModule.VFX[VFXName] then
		VFXModule.VFX[VFXName](Plr, Intensity, Duration)
	end
end

return VFXModule

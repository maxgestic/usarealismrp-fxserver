local jobs = {
    {name = "Meth", blip = {x = 1389.28, y = 3604.6, z = 38.9419, sprite = 499, color = 75}}
}

-- job blips
Citizen.CreateThread(function()
    for i=1,#jobs do
		local blip = AddBlipForCoord(jobs[i].blip.x, jobs[i].blip.y, jobs[i].blip.z)
		SetBlipSprite(blip, jobs[i].blip.sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.9)
		SetBlipColour(blip, jobs[i].blip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(jobs[i].blip.name)
		EndTextCommandSetBlipName(blip)
    end
end)

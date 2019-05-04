--[[ There is an example at the bottom commented out. Enjoy! ]]

-- Methods provided:

--- GetScaleform(string)
--- UnloadScaleform(scaleform)
--- IsLoaded(scaleform)
--- IsValid(scaleform)
--- CallFunction(scaleform, functionnamestring, arg1, arg2, arg3, etc...) 
--- RenderFullscreen(scaleform, r, g, b, a) -- rgba are not necessary and function will work without you providing them.
--- RenderRegion(scaleform, x, y, width, height, r, g, b, a) -- Same as last, rgba not necessary.
--- RenderScaleform3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
--- RenderAdditive3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale) -- Not sure what this does.
--- RenderSimple3D(handle, coords, rotation, scale) -- provide your own vector3's and should look way neater.

function GetScaleform(str)
	return RequestScaleformMovie(str)
end

-- Pass the above result into the following functions for them to work properly.

function UnloadScaleform(handle)
	if IsLoaded(handle) then
		SetScaleformMovieAsNoLongerNeeded(handle)
	end
end

function IsLoaded(handle)
	return HasScaleformMovieLoaded(handle)
end

function IsValid(handle)
	if handle~= 1 then
		--print("Scaleform is not valid.")
	end
	return handle ~= 0
end

function CallFunction(handle, func, ...) -- func is a string.
	args = {...}
	
	PushScaleformMovieFunction(handle, func)
	
	for i,v in ipairs(args) do -- Using ipairs ensures the order of args given.
		local success = false
		isafloat = isFloat(v)
		
		if (type(v) == "number") and not (isafloat) then
			PushScaleformMovieFunctionParameterInt(v)
			success = true
		end
		
		if (type(v) == "string") and ( string.len(v) > 99) then
		
			BeginTextCommandScaleformString()
			count = math.ceil(string.len(v)/99)

			for i = 0, math.ceil(string.len(v)/99), 1 do
				substring = string.sub(v, ((count * i) - 99), (count * i))
				AddTextComponentSubstringPlayerName(substring)
			end
			
			EndTextCommandScaleformString()
			success = true
		end
		
		if (type(v) == "string") and ( string.len(v) <= 99) then
			PushScaleformMovieFunctionParameterString(v)
			success = true
		end
		
		if (type(v) == "number") and (isafloat) then
			PushScaleformMovieFunctionParameterFloat(v)
			success = true
		end
		
		if type(v) == "bool" then
			PushScaleformMovieFunctionParameterBool(v)
			success = true
		end
		
		if not success then
			print("You have attempted to pass an incompatible variable to a scaleform function: " .. v)
		end
	end
	
	PopScaleformMovieFunctionVoid() -- Remove void to retrieve data from the func.
end

function RenderFullscreen(handle, r, g, b, a) -- 255 for each by default
	if (r == nil) and (g == nil) and (b == nil) and (a == nil) then
		r,g,b,a = 255
	end
	
	if IsValid(handle) then
		DrawScaleformMovieFullscreen(handle, r, g, b, a, 0)
	end
end

function RenderRegion(handle, x, y, width, height, r, g, b, a) -- 255 for each by default
	if (r == nil) and (g == nil) and (b == nil) and (a == nil) then
		r,g,b,a = 255
	end
	
	if IsValid(handle) then
		DrawScaleformMovie(handle, x, y, width, height, r, g, b, a, 0)
	end
end

function RenderScaleform3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
	if IsValid(handle) then
		DrawScaleformMovie3dNonAdditive(handle, xpos, ypos, zpos, xrot, yrot, zrot, 2.0, 2.0, 1.0, xscale, yscale, zscale)
	end
end

function RenderAdditive3D(handle, xpos, ypos, zpos, xrot, yrot, zrot, xscale, yscale, zscale)
	if IsValid(handle) then
		DrawScaleformMovie3d(handle, xpos, ypos, zpos, xrot, yrot, zrot, 2.0, 2.0, 1.0, xscale, yscale, zscale)
	end
end

function RenderSimple3D(handle, coords, rotation, scale) -- Provide your own vector3's
	if IsValid(handle) then
		DrawScaleformMovie3dNonAdditive(handle, coords, rotation, 2.0, 2.0, 1.0, scale)
	end
end

function isFloat(num)
	-- return "." == string.match(tostring(num), "%.")
	return #tostring(num) > #tostring(math.floor(num))
end

--[[
Citizen.CreateThread(function()
	scaleform = GetScaleform("heli_cam")
	i = 0
	while true do
		Wait(0)
		i = i + 1
		RenderFullscreen(scaleform)
		
		if i > 500 then -- Just random example of changing the thingy.
			x = math.random(10,100)
			CallFunction(scaleform, "SET_ALT_FOV_HEADING", 152.0 + x, 0.7, 90.0 + x)			
		end
		
		if i == 3500 then -- turns off after 30ish seconds
			UnloadScaleform(scaleform)
		end
	end
end)
]]
if SERVER then return end

local HideElements = { "DarkRP_HUD", "DarkRP_LocalPlayerHUD", "DarkRP_Hungermod", "CHudHealth","CHudBattery","CHudAmmo","CHudSecondaryAmmo" }

local function HUDShouldDraw( Element )

	if table.HasValue( HideElements, Element ) then return false end

end
hook.Add( "HUDShouldDraw", "HUDShouldDraw", HUDShouldDraw )

local ShieldTexture		= Material("hud/shield.png")	
local WalletTexture 	= Material("hud/coins.png")
local BorderTexture		= Material("hud/border.png")
local JobTexture		= Material("hud/briefcase.png")
local BarTexture		= Material("hud/bar.png")
local House			= Material("hud/house.png")



--[[---------------------------------------------------------
	Name: Custom Font
-----------------------------------------------------------]]
surface.CreateFont( "Hogwarts_HudFont", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


surface.CreateFont( "Hogwarts_HudFont_Small", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 10,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
--[[---------------------------------------------------------
	Name: FormatNumber
-----------------------------------------------------------]]
function FormatNumber( n )

	if not n then return "" end

	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1

	for i=dp-4, 1, -3 do

		n = n:sub(1, i) .. sep .. n:sub(i+1)
		
	end

	return n

end

--[[---------------------------------------------------------
	Name: DrawHUD
-----------------------------------------------------------]]
function DrawHUD()
	
	local SizeX = kbg_hud.Width
	local SizeY = kbg_hud.Height
	local NickLen = string.len( LocalPlayer():Nick() )
	local Weapon = LocalPlayer():GetActiveWeapon()
	local Networked = nil
	local health = LocalPlayer():Health()
	local maxhealth = 100
	local healthratio = math.Round(health*10/maxhealth)/10

	surface.SetFont( "Hogwarts_HudFont" )
	
	surface.SetDrawColor(255,255,255,255) -- Border
	surface.SetMaterial( BorderTexture )
	surface.DrawTexturedRect( 20, ScrH() - SizeY - 20,SizeX,SizeY )

	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( WalletTexture ) --Wallet Texture
	surface.DrawTexturedRect( 165, ScrH() - SizeY + 40,18,18 )
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetMaterial( JobTexture ) --Briefcase Texture
	surface.DrawTexturedRect( 164, ScrH() - SizeY + 60,18,18 )
	
	surface.SetTextPos( 55, ScrH() - 88.5 ) --Health_Bar
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetMaterial( BarTexture )
	surface.DrawTexturedRect( 150, ScrH() - SizeY + 10,200,20 )
	
	surface.SetTextPos( 114, ScrH() - 88.5 ) --Shield_Texture
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetMaterial( ShieldTexture )
	surface.DrawTexturedRect( 35,  ScrH() - SizeY - 10,100,100 )
	
	surface.SetTextPos( 46,  ScrH() - SizeY - 5 ) --House_Texture
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetMaterial( House )
	surface.DrawTexturedRect( 48,  ScrH() - SizeY + 65/2 - 22,65,65 )

	surface.SetTextPos( 190, ScrH() - SizeY + 40 ) --Player_Money
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawText( FormatNumber(LocalPlayer():getDarkRPVar("money")) )
	
	
	surface.SetTextPos( 190, ScrH() - SizeY + 60 ) --Player_Job
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.DrawText( team.GetName( LocalPlayer():Team() ) )
	
	
	local PlayerLevel = LocalPlayer():getDarkRPVar('level')
	local PlayerXP = LocalPlayer():getDarkRPVar('xp')
	local percent = ((PlayerXP or 0)/(((10+(((PlayerLevel or 1)*((PlayerLevel or 1)+1)*90))))*LevelSystemConfiguration.XPMult)) -- Gets the accurate level up percentage
	surface.SetTextPos( 165, ScrH() - SizeY - 10 ) --Player_Name
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetFont( "Hogwarts_HudFont" )
	if NickLen > 10 then
	surface.DrawText( string.sub(LocalPlayer():Nick(),1,10)..".." .." | Année: ".. LocalPlayer():getDarkRPVar('level') .. " | "..  math.floor(percent*100) .."%" )
	else
	surface.DrawText( LocalPlayer():Nick() .." | Année: ".. LocalPlayer():getDarkRPVar('level') .. " | "..  math.floor(percent*100) .."%")
	end	

	local ply = LocalPlayer()
	if ply:Alive() then

	surface.SetDrawColor( 159,136,162,255 )
	surface.DrawRect( 170, ScrH() - SizeY + 17,164*healthratio,6 )
	surface.SetDrawColor( 157,104,139,255 )
	surface.DrawRect( 170, ScrH() - SizeY + 17,164*healthratio,2 )
	surface.SetDrawColor( 157,104,139,255 )
	surface.DrawRect( 170, ScrH() - SizeY + 21,164*healthratio,2 )

end	
	
end
hook.Add("HUDPaint","DrawHud",DrawHUD)
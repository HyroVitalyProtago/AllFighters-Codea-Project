-- AllFighters
-- @Author : Hyro Vitaly Protago

PROJECTNAME = "AllFighters"
DESCRIPTION = "Platform/fighting game inspired by \"Jump Ultimate Stars\" and \"Super Smash Bross\"."
VERSION = "0.0.0"


SCREENS = {
	Main = AF_Main(), 					-- New Game | Editor | Options | About | ...
	GAME = {
		Main = AF_G_Main(), 			-- Local | LAN (Bluetooth) | Online
		Multi = {
			Main = AF_G_Multi(), 		-- Create/Join match
			Create = AF_G_Create(), 	-- Create a lan/online game
			Join = AF_G_Join() 			-- Join a lan/online game
		},
		Fighter = AF_G_Fighter(), 		-- Selection of fighter
		Power = AF_G_Power(),			-- Selection of power
		Level = AF_G_Level(), 			-- Selection of level
		Run = AF_G_Run() 				-- Current Game
	},
	EDITOR = {
		Main = AF_E_Main(), 			-- Fighters | Levels | Powers
		Fighters = {
			Main = AF_E_Fighters(), 	-- List of fighters
			FSprites = AF_E_FSprites(), -- List of characteristic and sprites of selected fighter
			FImages = AF_E_FImages() 	-- List of characteristic and images of selected sprite
		},
		Levels = {
			Main = AF_E_Levels() 		-- ...
		},
		Powers = {
			Main = AF_E_Powers() 		-- ...
		}
	},
	Options = AF_Options(), 			-- Custom options
	About = AF_About() 					-- See infos about game
}



function setup()
    saveProjectInfo("Author", "Hyro Vitaly Protago")
    saveProjectInfo("Description", DESCRIPTION)

    manager = Manager()
end

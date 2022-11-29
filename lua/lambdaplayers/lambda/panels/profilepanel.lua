local table_insert = table.insert
local ipairs = ipairs
local pairs = pairs
local round = math.Round
local random = math.random
local table_Merge = table.Merge
local table_Empty = table.Empty
local string_upper = string.upper
local isfunction = isfunction
local table_Copy = table.Copy
local string_Explode = string.Explode
local string_len = string.len
local string_Left = string.Left
local string_Right = string.Right

local function MakeNiceName( str )
    local newname = {}

    for _, s in pairs( string_Explode( "_", str ) ) do
        if ( string_len( s ) == 1 ) then table_insert( newname, string_upper( s ) ) continue end
        table_insert( newname, string_upper( string_Left( s, 1 ) ) .. string_Right( s, string_len( s ) - 1 ) )
    end

    return string.Implode( " ", newname )
end


-- Later I will make a Bodygroups and Skins settings for the panel by default

local function OpenProfilePanel( ply )
    if !IsValid( ply ) then return end

    local frame = LAMBDAPANELS:CreateFrame( "#lambda.profilepanel.title", 700, 350 )

    
    LAMBDAPANELS:CreateURLLabel( "#lambda.profilepanel.helpdesc", "https://github.com/IcyStarFrost/Lambda-Players/wiki/Adding-Custom-Content#lambda-profiles", frame, TOP )

    -- Profile Listing and buttons --
    local rightpanel = LAMBDAPANELS:CreateBasicPanel( frame )
    rightpanel:SetSize( 200, 200)
    rightpanel:Dock( RIGHT )


    local profilelist = vgui.Create( "DListView", rightpanel )
    profilelist:Dock( FILL )
    profilelist:AddColumn( "#lambda.profilepanel.profiles", 1 )

    local CompileSettings
    local ImportProfile
    local UpdateSBSliders
    local profiles = {}
    local profileinfo = {}

    local searchbar = LAMBDAPANELS:CreateSearchBar( profilelist, profiles, rightpanel, true )
    searchbar:Dock( TOP )

    local localprofiles = LAMBDAFS:ReadFile( "lambdaplayers/profiles.json", "json" )

    if localprofiles then
        for k, v in SortedPairs( localprofiles ) do
            local line =  profilelist:AddLine( k .. " | Local" )
            line.l_isprofilelocal = true
            line:SetSortValue( 1, v )
        end

        table_Merge( profiles, localprofiles )
    end

    local function UpdateprofileLine( profilename, newinfo, islocal )
        local lines = profilelist:GetLines()

        for k, v in ipairs( lines ) do
            local info = v:GetSortValue( 1 )
            if info.name == profilename then v:SetSortValue( 1, newinfo ) return end
        end

        local line =  profilelist:AddLine( newinfo.name .. ( islocal and " | "..language.GetPhrase( "lambda.profilepanel.local" ) or " | "..language.GetPhrase( "lambda.profilepanel.server" ) ) )
        line.l_isprofilelocal = islocal
        line:SetSortValue( 1, newinfo )
    end

    function profilelist:DoDoubleClick( id, line )
        ImportProfile( line:GetSortValue( 1 ) )
        surface.PlaySound( "buttons/button15.wav" )
    end

    function profilelist:OnRowRightClick( id, line )
        local conmenu = DermaMenu( false )
        local x, y = input.GetCursorPos()
        conmenu:SetPos( x, y + 10)
        local info = line:GetSortValue( 1 )

        conmenu:AddOption( "#lambda.profilepanel.cancel", function() end )
        conmenu:AddOption( language.GetPhrase( "lambda.profilepanel.delete" ) .. info.name .. "?", function()
            
            if line.l_isprofilelocal then
                LAMBDAFS:RemoveVarFromKVFile( "lambdaplayers/profiles.json", info.name, "json" )
                surface.PlaySound( "buttons/button15.wav" )
                chat.AddText( language.GetPhrase( "lambda.profilepanel.deleted" ) .. info.name .. language.GetPhrase( "lambda.profilepanel.deletedlocal" ) )
                profilelist:RemoveLine( id )
            else
                LAMBDAPANELS:RemoveVarFromKVFile( "lambdaplayers/profiles.json", info.name, "json" ) 
                surface.PlaySound( "buttons/button15.wav" )
                chat.AddText( language.GetPhrase( "lambda.profilepanel.deleted" ) .. info.name .. language.GetPhrase( "lambda.profilepanel.deletedserver") )
                profilelist:RemoveLine( id )
            end
        end )
    end

    LAMBDAPANELS:CreateButton( rightpanel, BOTTOM, "Save Profile", function()
        local compiledinfo = CompileSettings()

        chat.AddText( "Saved " .. compiledinfo.name .. " to your Profiles!" )
        surface.PlaySound( "buttons/button15.wav" )

        UpdateprofileLine( compiledinfo.name, compiledinfo, true )
        if !LAMBDAFS:FileHasValue( "lambdaplayers/customnames.json", compiledinfo.name, "json" ) then LAMBDAFS:UpdateSequentialFile( "lambdaplayers/customnames.json", compiledinfo.name, "json" )  end
        LAMBDAFS:UpdateKeyValueFile( "lambdaplayers/profiles.json", { [ compiledinfo.name ] = compiledinfo }, "json" ) 
    end )

    LAMBDAPANELS:CreateButton( rightpanel, BOTTOM, "Save To Server", function()
        if !LocalPlayer():IsSuperAdmin() then chat.AddText( "You must be a Super Admin to save profiles to the Server! " ) return end
        local compiledinfo = CompileSettings()

        surface.PlaySound( "buttons/button15.wav" )
        chat.AddText( "Saved " .. compiledinfo.name .. " to the Server's Profiles. Make sure the name exists in the Server's names by using the Name Panel")

        local line =  profilelist:AddLine( compiledinfo.name .. " | Server" )
        line.l_isprofilelocal = false
        line:SetSortValue( 1, compiledinfo )
        if LocalPlayer():GetNW2Bool( "lambda_serverhost", false ) and !LAMBDAFS:FileHasValue( "lambdaplayers/customnames.json", compiledinfo.name, "json" ) then LAMBDAFS:UpdateSequentialFile( "lambdaplayers/customnames.json", compiledinfo.name, "json" ) end

        UpdateprofileLine( compiledinfo.name, compiledinfo, true )
        LAMBDAPANELS:UpdateKeyValueFile( "lambdaplayers/profiles.json", { [ compiledinfo.name ] = compiledinfo }, "json" ) 
    end )

    LAMBDAPANELS:CreateButton( rightpanel, BOTTOM, "Request Server Profiles", function()
        if LocalPlayer():GetNW2Bool( "lambda_serverhost", false ) then chat.AddText( "You are the server host!" ) return end
        if !LocalPlayer():IsSuperAdmin() then chat.AddText( "You must be a Super Admin to request the Server's Profiles!" ) return end
        LAMBDAPANELS:RequestDataFromServer( "lambdaplayers/profiles.json", "json", function( data )
            if !data then chat.AddText( "The Server has no profiles to send!" ) return end

            profilelist:Clear()
            table_Empty( profiles )
            table_Merge( profiles, data )
            
            for k, v in SortedPairs( data ) do
                local line =  profilelist:AddLine( k .. " | SERVER" )
                line.l_isprofilelocal = false
                line:SetSortValue( 1, v )
            end
        end )
    end )


    LAMBDAPANELS:CreateButton( rightpanel, BOTTOM, "Validate Profiles", function()

        local hasissue = false
        for k, v in pairs( profiles ) do
            
            if v.model and !file.Exists( v.model, "GAME" ) then hasissue = true print( "Lambda Profile Validate: " .. k .. " has a error playermodel! ( " .. v.model .. " )" ) end
            if v.voiceprofile and !file.Exists( "sound/lambdaplayers/voiceprofiles/" .. v.voiceprofile, "GAME" ) then hasissue = true print( "Lambda Profile Validate: " .. k .. " has a non existent Voice Profile! ( " .. v.voiceprofile .. " )" ) end
            if v.spawnwep and !_LAMBDAPLAYERSWEAPONS[ v.spawnwep ] then hasissue = true print( "Lambda Profile Validate: " .. k .. " has a non existent Spawn Weapon! ( " .. v.spawnwep .. " )" ) end
            if v.profilepicture and !file.Exists( "materials/" .. v.profilepicture, "GAME" ) then hasissue = true print( "Lambda Profile Validate: " .. k .. " has a non existent Profile Picture! ( " .. v.profilepicture .. " )" ) end

        end

        chat.AddText( "Validation complete." .. ( hasissue and " Some issues were found. Check Console" or " No issues were found" ) )
    end )



--[[     LAMBDAPANELS:CreateButton( rightpanel, BOTTOM, "Import Zeta Profiles", function()
        Derma_Query( "Are you sure you want to import your Zeta Profiles? Note that the importing will not be perfect and you may have to edit the profiles!", "CONFIRMATION:", "Yes", function()
            
            if file.Exists( "zetaplayerdata/profiles.json", "DATA" ) then
                local zetaprofiles = LAMBDAFS:ReadFile( "zetaplayerdata/profiles.json", "json" )

                for key, profiletbl in pairs( zetaprofiles ) do
                    
                    local translationinfo = {
                        name = profiletbl.name,
                        model = profiletbl.playermodel and profiletbl.playermodel or nil,
                        profilepicture = profiletbl.avatar and "lambdaplayers/custom_profilepictures/" .. profiletbl.avatar or nil,

                        plycolor = profiletbl.playermodelcolor and Vector( profiletbl.playermodelcolor.r / 255, profiletbl.playermodelcolor.g / 255, profiletbl.playermodelcolor.b / 255  ) or Vector( 1, 1, 1), 
                        physcolor = profiletbl.physguncolor and Vector( profiletbl.physguncolor.r / 255, profiletbl.physguncolor.g / 255, profiletbl.physguncolor.b / 255  ) or Vector( 1, 1, 1 ),
            
                        voicepitch = profiletbl.voicepitch and round( profiletbl.voicepitch, 0 ) or 100,
                        voice = profiletbl.personality and round( profiletbl.personality.voice, 0 ) or 30,
                        voiceprofile = profiletbl.voicepack or nil,
                        pingrange = random( 1, 120 ),

                        personality = {
                            Build = profiletbl.personality and profiletbl.personality.build or 30,
                            Combat = profiletbl.personality and profiletbl.personality.combat or 30,
                            Tool = profiletbl.personality and profiletbl.personality.tool or 30
                        }

                    }

                    local line =  profilelist:AddLine( key .. " | Local" )
                    line.l_isprofilelocal = false
                    line:SetSortValue( 1, translationinfo )

                    LAMBDAFS:UpdateKeyValueFile( "lambdaplayers/profiles.json", { [ translationinfo.name ] = translationinfo }, "json" ) 
                end

                chat.AddText( "Imported all Zeta Profiles to Lambda successfully!" )
            else
                Derma_Message( "There are no profiles to import", "Import Failed", "Ok")
            end

        
        end, "No")
    end ) ]]

    ---- ---- ---- ---- ---- ----


    local scroll = LAMBDAPANELS:CreateScrollPanel( frame, true, FILL )

    ---- First Left Settings Panel ----

    local mainpanel = LAMBDAPANELS:CreateBasicPanel( scroll )
    mainpanel:SetSize( 250, 200 )
    mainpanel:Dock( LEFT )
    scroll:AddPanel( mainpanel )

    local mainscroll = LAMBDAPANELS:CreateScrollPanel( mainpanel, false, FILL )

    LAMBDAPANELS:CreateLabel( "Lambda Name", mainscroll, TOP )
    local name = LAMBDAPANELS:CreateTextEntry( mainscroll, TOP, "Enter a name here" )

    LAMBDAPANELS:CreateLabel( "Player Model", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "Leave blank for random", mainscroll, TOP )
    local model = LAMBDAPANELS:CreateTextEntry( mainscroll, TOP, "Enter a model path" )

    LAMBDAPANELS:CreateLabel( "Profile Picture", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "Enter a file path relative to", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "materials/lambdaplayers/custom_profilepictures", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "Leave Blank for random", mainscroll, TOP )
    LAMBDAPANELS:CreateURLLabel( "Click here to learn about Profile Pictures", "https://github.com/IcyStarFrost/Lambda-Players/wiki/Adding-Custom-Content#profile-pictures", mainscroll, TOP )
    local profilepicture = LAMBDAPANELS:CreateTextEntry( mainscroll, TOP, "Enter a file path" )

    local pfppreview = vgui.Create( "DImage", mainscroll )
    pfppreview:SetSize( 100, 150 )
    pfppreview:Dock( TOP ) 

    function profilepicture:OnChange() 
        local text = profilepicture:GetText()
        if file.Exists( "materials/lambdaplayers/custom_profilepictures/" .. text, "GAME" ) then pfppreview:SetMaterial( Material( "lambdaplayers/custom_profilepictures/" .. text ) ) end
    end

    LAMBDAPANELS:CreateLabel( "Voice Profile", mainscroll, TOP )
    LAMBDAPANELS:CreateURLLabel( "Click here to learn about Voice Profiles", "https://github.com/IcyStarFrost/Lambda-Players/wiki/Adding-Custom-Content#voice-profiles", mainscroll, TOP )
    local combotable = {}
    for k, v in pairs( LAMBDAFS:GetVoiceProfiles() ) do
        combotable[ k ] = k
    end
    combotable[ "No Voice Profile" ] = "/NIL"
    local voiceprofile = LAMBDAPANELS:CreateComboBox( mainscroll, TOP, combotable )

    LAMBDAPANELS:CreateLabel( "Voice Pitch", mainscroll, TOP )
    local voicepitch = LAMBDAPANELS:CreateNumSlider( mainscroll, TOP, 100, "Voice Pitch", 30, 255, 0 )

    LAMBDAPANELS:CreateLabel( "Spawn Weapon", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "The weapon to spawn with", mainscroll, TOP )
    local copy = table_Copy( _LAMBDAWEAPONCLASSANDPRINTS )
    copy[ "No Weapon" ] = "/NIL"
    local spawnweapon = LAMBDAPANELS:CreateComboBox( mainscroll, TOP, copy )

    LAMBDAPANELS:CreateLabel( "Ping", mainscroll, TOP )
    LAMBDAPANELS:CreateLabel( "The lowest point this Lambda's Ping can get", mainscroll, TOP )
    local pingrange = LAMBDAPANELS:CreateNumSlider( mainscroll, TOP, 100, "Ping Range", 1, 130, 0 )

    ---- ---- ---- ---- ---- ----


    ---- Easy Playermodel selecting ----
    local main2panel = LAMBDAPANELS:CreateBasicPanel( scroll )
    main2panel:SetSize( 300, 200 )
    main2panel:Dock( LEFT )
    scroll:AddPanel( main2panel )

    LAMBDAPANELS:CreateLabel( "-- Easy Playermodel Selections --", main2panel, TOP )
    LAMBDAPANELS:CreateLabel( "Click on a model to easily use it", main2panel, TOP )
    local main2scroll = LAMBDAPANELS:CreateScrollPanel( main2panel, false, FILL )

    local List = vgui.Create( "DIconLayout", main2scroll )
    List:Dock( FILL )
    List:SetSpaceY( 12 )
    List:SetSpaceX( 12 )

    for k, v in pairs( player_manager.AllValidModels() ) do
        local mdlbutton = List:Add( "SpawnIcon" )
        mdlbutton:SetModel( v )
        
        function mdlbutton:DoClick()
            model:SetText( mdlbutton:GetModelName() )
            model:OnChange()
        end
    end
    ---- ---- ---- ---- ---- ----


    ---- Playermodel Preview ----
    local playermodelpreviewframe = LAMBDAPANELS:CreateBasicPanel( scroll )
    playermodelpreviewframe:SetSize( 300, 200 )
    playermodelpreviewframe:Dock( LEFT )
    scroll:AddPanel( playermodelpreviewframe )

    LAMBDAPANELS:CreateLabel( "-- Playermodel Preview --", playermodelpreviewframe, TOP )

    local playermodelpreview = vgui.Create( "DModelPanel", playermodelpreviewframe )
    playermodelpreview:SetSize( 300, 400)
    playermodelpreview:Dock( TOP )
    playermodelpreview:SetModel( "models/error.mdl" )

    function playermodelpreview:LayoutEntity( Entity )
        Entity:SetAngles( Angle( 0, RealTime() * 20 % 360, 0 ) )
    end

    function playermodelpreview:UpdateColors( vector )
        if !vector or !self:GetEntity() then return end
        self:GetEntity().GetPlayerColor = function() return vector end
    end

    function model:OnChange() 
        playermodelpreview:SetModel( model:GetText() != "" and model:GetText() or "models/error.mdl" )
        if isfunction( UpdateSBSliders ) then UpdateSBSliders() end
    end
    ---- ---- ---- ---- ---- ----




    ---- Personality settings ----
    local personalitysliders = {}
    local personalitypanel = LAMBDAPANELS:CreateBasicPanel( scroll )
    personalitypanel:SetSize( 200, 200 )
    personalitypanel:Dock( LEFT )
    scroll:AddPanel( personalitypanel )



    local personalityscroll = LAMBDAPANELS:CreateScrollPanel( personalitypanel, false, FILL )
    LAMBDAPANELS:CreateLabel( "-- Personality Settings --", personalityscroll, TOP )
    LAMBDAPANELS:CreateLabel( "If this Profile should", personalityscroll, TOP )
    LAMBDAPANELS:CreateLabel( "use these sliders", personalityscroll, TOP )
    local usepersonality = LAMBDAPANELS:CreateCheckBox( personalityscroll, TOP, true, "Use Personality Slider" )

    for k, v in ipairs( LambdaPersonalities ) do 
        local numslider = LAMBDAPANELS:CreateNumSlider( personalityscroll, TOP, 30, v[ 1 ], 0, 100, 0 )
        personalitysliders[ v[ 1 ] ] = numslider
    end

    local voicechance = LAMBDAPANELS:CreateNumSlider( personalityscroll, TOP, 30, "Voice", 0, 100, 0 )
    ---- ---- ---- ---- ---- ----


    ---- Colors ----
    local colorframe = LAMBDAPANELS:CreateBasicPanel( scroll )
    colorframe:SetSize( 200, 200 )
    colorframe:Dock( LEFT )
    scroll:AddPanel( colorframe )

    local colorscroll = LAMBDAPANELS:CreateScrollPanel( colorframe, false, FILL )

    

    LAMBDAPANELS:CreateLabel( "-- Playermodel Color --", colorscroll, TOP )
    local useplycolor = LAMBDAPANELS:CreateCheckBox( colorscroll, TOP, true, "Use Playermodel Color" )
    local playermodelcolor = LAMBDAPANELS:CreateColorMixer( colorscroll, TOP )

    function playermodelcolor:ValueChanged( col )
        playermodelpreview:UpdateColors( Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    end


    LAMBDAPANELS:CreateLabel( "-- Physgun Color --", colorscroll, TOP )
    local usephyscolor = LAMBDAPANELS:CreateCheckBox( colorscroll, TOP, true, "Use Physgun Color" )
    local physguncolor = LAMBDAPANELS:CreateColorMixer( colorscroll, TOP )
    ---- ---- ---- ---- ---- ----


    ---- Skins and bodygroups ----
    local skinslider
    local bodygroupdata = {}
    local sbframe = LAMBDAPANELS:CreateBasicPanel( scroll )
    sbframe:SetSize( 200, 200 )
    sbframe:Dock( LEFT )
    scroll:AddPanel( sbframe )

    LAMBDAPANELS:CreateLabel( "-- BodyGroups/Skins --", sbframe, TOP )

    local sbscroll = LAMBDAPANELS:CreateScrollPanel( sbframe, false, FILL )
    

    UpdateSBSliders = function()
        local ent = playermodelpreview:GetEntity()

        if skinslider then skinslider:Remove() skinslider = nil end
        for k, v in pairs( bodygroupdata ) do if v then v:Remove() v = nil end end

        skinslider = LAMBDAPANELS:CreateNumSlider( sbscroll, TOP, 0, "Skin", 0, ent:SkinCount() - 1, 0 )

        function skinslider:OnValueChanged( val ) ent:SetSkin( round( val, 0 ) ) end
        
        for _, v in ipairs( ent:GetBodyGroups() ) do
            local smds = #v.submodels
            if smds == 0 then continue end 

            local bgslider = LAMBDAPANELS:CreateNumSlider( sbscroll, TOP, 0, MakeNiceName( v.name ), 0, smds, 0 )

            function bgslider:OnValueChanged( val )
                ent:SetBodygroup( v.id, round( val, 0 ))
            end

            bodygroupdata[ v.id ] = bgslider
        end

    end

    UpdateSBSliders()

    ---- ---- ---- ---- ---- ----


    ---- External addon panels ----
    local externalpanels = {}
    local categories = {}

    for k, v in ipairs( LambdaPlayersProfileExternalpanels ) do
        local class, variablename, category, callback  = v[ 1 ], v[ 2 ], v[ 3 ], v[ 4 ]
        local externalscroll

        if !categories[ category ] then
            local externalpanel = LAMBDAPANELS:CreateBasicPanel( scroll )
            externalpanel:SetSize( 200, 200 )
            externalpanel:Dock( LEFT )
            scroll:AddPanel( externalpanel )
        
            externalscroll = LAMBDAPANELS:CreateScrollPanel( externalpanel, false, FILL )
            LAMBDAPANELS:CreateLabel( "-- " .. category .. " --", externalscroll, TOP )

            categories[ category ] = externalscroll
        end

        local extpnl

        if class == "DComboBox" then extpnl = LAMBDAPANELS:CreateComboBox( categories[ category ], TOP, {} ) else extpnl = vgui.Create( class, categories[ category ] ) end
        extpnl:Dock( TOP )
        extpnl.LambdapnlClass = class
        externalpanels[ variablename ] = extpnl
        callback( extpnl, externalscroll )
        

    end
    ---- ---- ---- ---- ---- ----

    CompileSettings = function()
        if name:GetText() == "" then chat.AddText( "No name is set!" ) return end
        local _, vp = voiceprofile:GetSelected()
        local _, weapon = spawnweapon:GetSelected()
        local infotable = {

            name = name:GetText(),
            model = model:GetText() != "" and model:GetText() or nil,
            profilepicture = profilepicture:GetText() != "" and "lambdaplayers/custom_profilepictures/" .. profilepicture:GetText() or nil,

            plycolor = useplycolor:GetChecked() and playermodelcolor:GetVector() or nil,
            physcolor = usephyscolor:GetChecked() and physguncolor:GetVector() or nil,
            
            mdlSkin = round( skinslider:GetValue(), 0 ),
            
            voicepitch = round( voicepitch:GetValue(), 0 ),
            voice = usepersonality:GetChecked() and round( voicechance:GetValue(), 0 ) or nil,
            voiceprofile = vp != "/NIL" and vp or nil,
            pingrange = round( pingrange:GetValue(), 0 ),

            externalvars = profileinfo and profileinfo.externalvars or nil,

            spawnwep = weapon != "/NIL" and weapon or nil

        }

        infotable.bodygroups = {}
        for k, v in pairs( bodygroupdata ) do
            if infotable.bodygroups[ k ] then infotable.bodygroups[ k ] = round( v:GetValue(), 0 ) end
        end

        for k, v in pairs( externalpanels ) do
            infotable.externalvars = infotable.externalvars or {}
            infotable.externalvars[ k ] = LAMBDAPANELS:GetValue( v )
        end

        if usepersonality:GetChecked() then
            infotable.personality = {}
            for k, v in pairs( personalitysliders ) do
                infotable.personality[ k ] = round( v:GetValue(), 0 )
            end
        else
            infotable.personality = nil
        end


        return infotable
    end


    ImportProfile = function( infotable )
        local ent = playermodelpreview:GetEntity()
        profileinfo = infotable
        
        name:SetText( infotable.name )
        model:SetText( infotable.model or "" )

        if infotable.profilepicture then
            local isspawnicon = string.StartWith( infotable.profilepicture, "spawnicons/" )

            profilepicture:SetText( !isspawnicon and string.Replace( infotable.profilepicture, "lambdaplayers/custom_profilepictures/", "" ) or "" )
        else
            profilepicture:SetText( "" )
        end
        
        useplycolor:SetChecked( infotable.plycolor != nil )
        usephyscolor:SetChecked( infotable.physcolor != nil )
        playermodelcolor:SetVector( infotable.plycolor or Vector( 1, 1, 1 ) )
        physguncolor:SetVector( infotable.physcolor or Vector( 1, 1, 1 ) )

        profilepicture:OnChange()
        model:OnChange()
        playermodelpreview:UpdateColors( infotable.plycolor )

        skinslider:SetValue( infotable.mdlSkin or 0 )
        ent:SetSkin( infotable.mdlSkin or 0 )

        if infotable.bodygroups then
            for k, v in pairs( infotable.bodygroups ) do
                bodygroupdata[ k ]:SetValue( v )
                ent:SetBodygroup( k, v )
            end
        end

        voicepitch:SetValue( infotable.voicepitch )
        voicechance:SetValue( infotable.voice )
        if infotable.voiceprofile then voiceprofile:SelectOptionByKey( infotable.voiceprofile ) else voiceprofile:SelectOptionByKey( "/NIL" ) end
        
        pingrange:SetValue( infotable.pingrange )

        if infotable.spawnwep then spawnweapon:SelectOptionByKey( infotable.spawnwep ) else spawnweapon:SelectOptionByKey( "/NIL" ) end

        if infotable.externalvars then
            for k, v in pairs( infotable.externalvars ) do
                if externalpanels[ k ] then
                    LAMBDAPANELS:SetValue( externalpanels[ k ], v )
                end
            end
        end

        if infotable.personality then
            usepersonality:SetChecked( true )
            for k, v in pairs( infotable.personality ) do
                local slider = personalitysliders[ k ]
                if slider then slider:SetValue( v ) end
            end
        else
            for k, v in pairs( personalitysliders ) do v:SetValue( 30 ) end
            usepersonality:SetChecked( false )
        end
    end

end

RegisterLambdaPanel( "Profile", "Opens a panel that allows you to create profiles of specific names/Lambdas.", OpenProfilePanel )
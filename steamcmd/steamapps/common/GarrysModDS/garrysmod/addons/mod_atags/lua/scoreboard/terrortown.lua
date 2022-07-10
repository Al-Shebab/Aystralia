local header = "" -- Header of the column
local nameColor = false -- Color of the name the same as the color of the tag.
local addX = 0 -- Add to X position of the column.

local function SetTag( pnl )
	
	local column = pnl:AddColumn( header, function( ply, label )
	
		local name, color = hook.Call( "aTag_GetScoreboardTag", nil, ply )
		
		if nameColor and pnl.nick and name and name != "" then
			pnl.nick.Paint = function( self, w, h )
				
				draw.SimpleText( self:GetValue(), self:GetFont(), 0, 0, color or self:GetTextColor(), TEXT_ALIGN_LEFT )
				
				return true
			end
		end
		
		label:SetTextColor( color )
		
		return name
		
	end, 140 + ATAG.scoreboardPosition )
	
	column.addX = addX
	
	-- overrides D:
	
	if pnl.ClassName == "TTTScorePlayerRow" then
	
		function pnl:LayoutColumns()
		
			local cx = self:GetWide()
			for k, v in ipairs( self.cols ) do
				v:SizeToContents()
				cx = cx - v.Width
				v:SetPos( cx - v:GetWide()/2 + ( v.addX or 0 ), ( SB_ROW_HEIGHT - v:GetTall() ) / 2 )
			end

			self.tag:SizeToContents()
			cx = cx - 90
			self.tag:SetPos( cx - self.tag:GetWide()/2, ( SB_ROW_HEIGHT - self.tag:GetTall() ) / 2 )

			self.sresult:SetPos( cx - 8, ( SB_ROW_HEIGHT - 16 ) / 2 )
			
		end
	
	elseif pnl.ClassName == "TTTScoreboard" then
	
		local y_logo_off = 72
	
		function pnl:PerformLayout()
		   -- position groups and find their total size
		   local gy = 0
		   -- can't just use pairs (undefined ordering) or ipairs (group 2 and 3 might not exist)
		   for i=1, GROUP_COUNT do
			  local group = self.ply_groups[i]
			  if ValidPanel(group) then
				 if group:HasRows() then
					group:SetVisible(true)
					group:SetPos(0, gy)
					group:SetSize(self.ply_frame:GetWide(), group:GetTall())
					group:InvalidateLayout()
					gy = gy + group:GetTall() + 5
				 else
					group:SetVisible(false)
				 end
			  end
		   end

		   self.ply_frame:GetCanvas():SetSize(self.ply_frame:GetCanvas():GetWide(), gy)

		   local h = y_logo_off + 110 + self.ply_frame:GetCanvas():GetTall()

		   -- if we will have to clamp our height, enable the mouse so player can scroll
		   local scrolling = h > ScrH() * 0.95
		--   gui.EnableScreenClicker(scrolling)
		   self.ply_frame:SetScroll(scrolling)

		   h = math.Clamp(h, 110 + y_logo_off, ScrH() * 0.95)

		   local w = math.max(ScrW() * 0.6, 640)

		   self:SetSize(w, h)
		   self:SetPos( (ScrW() - w) / 2, math.min(72, (ScrH() - h) / 4))

		   self.ply_frame:SetPos(8, y_logo_off + 109)
		   self.ply_frame:SetSize(self:GetWide() - 16, self:GetTall() - 109 - y_logo_off - 5)

		   -- server stuff
		   self.hostdesc:SizeToContents()
		   self.hostdesc:SetPos(w - self.hostdesc:GetWide() - 8, y_logo_off + 5)

		   local hw = w - 180 - 8
		   self.hostname:SetSize(hw, 32)
		   self.hostname:SetPos(w - self.hostname:GetWide() - 8, y_logo_off + 27)

		   surface.SetFont("cool_large")
		   local hname = self.hostname:GetValue()
		   local tw, _ = surface.GetTextSize(hname)
		   while tw > hw do
			  hname = string.sub(hname, 1, -6) .. "..."
			  tw, th = surface.GetTextSize(hname)
		   end

		   self.hostname:SetText(hname)

		   self.mapchange:SizeToContents()
		   self.mapchange:SetPos(w - self.mapchange:GetWide() - 8, y_logo_off + 60)

		   -- score columns
		   local cy = y_logo_off + 90
		   local cx = w - 8 -(scrolling and 16 or 0)
		   for k,v in ipairs(self.cols) do
			  v:SizeToContents()
			  cx = cx - v.Width
			  v:SetPos(cx - v:GetWide()/2 + ( v.addX or 0 ), cy)
		   end
		end
	
	end
	
end
if EZS then
	hook.Add( "EZS_AddColumns", "ATAG_TagColumnsSet", SetTag )
else
	hook.Add( "TTTScoreboardColumns", "ATAG_TagColumnsSet", SetTag )
end
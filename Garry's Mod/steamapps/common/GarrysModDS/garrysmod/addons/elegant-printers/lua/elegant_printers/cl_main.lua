net.Receive("elegant_printers_event_announce", function()
    local mult = net.ReadFloat()
    local duration = net.ReadFloat()

    mult = (mult - 1) * 100
    mult = (mult > 0 and "+" or "") .. mult .. "%"

    chat.AddText(elegant_printers.config.CommunityColor, "[" .. elegant_printers.config.CommunityName .. "] ", Color(255, 255, 255), "Money printers will now generate " .. mult .. " money for the next " .. string.NiceTime(duration) .. "!")
end)

if IsValid(elegant_printers.LogoPanel) then elegant_printers.LogoPanel:Remove() end
local panel = vgui.Create("DHTML")
panel:Dock(FILL)
panel:SetAlpha(0)
panel:SetMouseInputEnabled(false)
function panel:ConsoleMessage(msg) end
panel:SetHTML([[
<!DOCTYPE html>
<html>
	<head>
		<style>
		body, html {
			padding: 0;
			margin: 0;
			overflow: hidden;
		}
		img {
			max-width: 100%;
			max-height: 102px;
		}
		</style>
	</head>
	<body>
		<img id="img"></img>
		<script>
			var url = "]] .. string.JavascriptSafe(elegant_printers.config.LogoURL) .. [[";
			document.getElementById("img").src = url;
		</script>
	</body>
</html>
]])
elegant_printers.LogoPanel = panel

elegant_printers.Print("Loaded client")

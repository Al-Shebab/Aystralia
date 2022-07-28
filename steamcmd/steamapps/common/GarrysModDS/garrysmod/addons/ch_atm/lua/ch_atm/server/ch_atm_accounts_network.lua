--[[
	Depositing money into the players bank account
--]]
net.Receive( "CH_ATM_Net_DepositMoney", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	local amount = math.Round( net.ReadUInt( 32 ) )
	local ply_money_wallet = CH_ATM.GetMoney( ply )
	
	local atm = net.ReadEntity()
	
	-- Perform a series of security checks before completing the deposit.
	if amount > ply_money_wallet then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You don't have this much money!" ) )
		return
	end
	
	if amount <= 0 then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The amount must be positive!" ) )
		return
	end
	
	if not CH_ATM.IsPlayerCloseToAnATM( ply ) then
		return
	end
	
	if atm:GetIsBeingHacked() or atm:GetIsHackCooldown() then
		return
	end
	
	-- All checks passed so add money to bank
	CH_ATM.AddMoneyToBankAccount( ply, amount )
	
	-- Take money from the players wallet
	CH_ATM.TakeMoney( ply, amount )
	
	if CH_ATM.Config.SlideMoneyOutOfATM then
		CH_ATM.PushMoneyIntoATM( ply, atm )
	end
	
	-- Log transaction (only works with SQL enabled)
	CH_ATM.LogSQLTransaction( ply, "deposit", amount )

	-- bLogs support
	hook.Run( "CH_ATM_bLogs_DepositMoney", ply, amount )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You have deposited" ) .." ".. CH_ATM.FormatMoney( amount ) )
end )

--[[
	Withdraw money from bank account
--]]
net.Receive( "CH_ATM_Net_WithdrawMoney", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	local amount = math.Round( net.ReadUInt( 32 ) )
	local ply_bank_account = CH_ATM.GetMoneyBankAccount( ply )
	
	local atm = net.ReadEntity()
	
	-- Perform a series of security checks before completing the deposit.
	if amount > ply_bank_account then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You don't have this much money!" ) )
		return
	end
	
	if amount <= 0 then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The amount must be positive!" ) )
		return
	end
	
	if not CH_ATM.IsPlayerCloseToAnATM( ply ) then
		return
	end
	
	if atm:GetIsBeingHacked() or atm:GetIsHackCooldown() then
		return
	end
	
	-- All checks passed so take money from bank account
	CH_ATM.TakeMoneyFromBankAccount( ply, amount )
	
	-- Add money to players wallet / slide out of ATM
	if CH_ATM.Config.SlideMoneyOutOfATM then
		CH_ATM.PushMoneyOutOfATM( ply, atm, amount )
	else
		CH_ATM.AddMoney( ply, amount )
	end
	
	-- Log transaction (only works with SQL enabled)
	CH_ATM.LogSQLTransaction( ply, "withdraw", amount )
	
	-- bLogs support
	hook.Run( "CH_ATM_bLogs_WithdrawMoney", ply, amount )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You have withdrawn" ) .." ".. CH_ATM.FormatMoney( amount ) )
end )

--[[
	Sending money to other players bank accounts
--]]
net.Receive( "CH_ATM_Net_SendMoney", function( len, ply )
	if ( ply.CH_ATM_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_ATM_NetDelay = CurTime() + 1
	
	local amount = math.Round( net.ReadUInt( 32 ) )
	local receiver = net.ReadEntity()
	local ply_bank_account = CH_ATM.GetMoneyBankAccount( ply )

	-- Perform a series of security checks before completing the deposit.
	if amount > ply_bank_account then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You don't have this much money!" ) )
		return
	end
	
	if amount <= 0 then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The amount must be positive!" ) )
		return
	end
	
	if not CH_ATM.IsPlayerCloseToAnATM( ply ) then
		return
	end
	
	if not IsValid( receiver ) then
		return
	end
	
	-- If all checks passed then send the money
	
	-- Take money from the SENDER bank account
	CH_ATM.TakeMoneyFromBankAccount( ply, amount )
	
	-- Add to the RECEIVER bank account
	CH_ATM.AddMoneyToBankAccount( receiver, amount )
	
	-- Log transaction (only works with SQL enabled)
	CH_ATM.LogSQLTransaction( ply, "transfer", amount )
	
	-- bLogs support
	hook.Run( "CH_ATM_bLogs_SendMoney", ply, amount, receiver )
	
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You have sent" ) .." ".. CH_ATM.FormatMoney( amount ) .." to " .. receiver:Nick() )
	CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The money has been deducted from your bank account." ) )
	
	CH_ATM.NotifyPlayer( receiver, CH_ATM.LangString( "You have received" ) .." ".. CH_ATM.FormatMoney( amount ) .." from " .. ply:Nick() )
	CH_ATM.NotifyPlayer( receiver, CH_ATM.LangString( "The money has been sent to your bank account." ) )
end )
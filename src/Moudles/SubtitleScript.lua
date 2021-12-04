PlayerController = require('Moudles/PlayerController')
local Subtitle = {}
	
	function Subtitle:Meeting(id,first,text,subtitleData)
		if PlayerController:IsCameraOn() or PlayerController:IsAlbumOn() or PlayerController:IsInteractionOn() then
			return
		end

		PlayerController:ChooseMode()
		PlayerController.AllowMove = false
		PlayerController:SetDialogOn(true)

		local i=1;
		local isPrint=true;
		local isOver=false;

		co1=coroutine.create(function()
			if first then
			
				local words = "word"..i;
				local message=subtitleData:GetCell(words,id);

				while message ~= "" do
					isPrint=true;
					local words_data="";
					for temp in string.gmatch(message,"[%z\1-\127\194-\244][\128-\191]*") do
						
						if isPrint==false then
							words_data=message;
							text.Text=words_data;
							wait(0.05);
							break;
						end

						words_data=words_data..temp;
						text.Text=words_data;
						wait(0.05);
					end
					isPrint=false;
					i=i+1;
					words="word"..i;
					message=subtitleData:GetCell(words,id);
					
					coroutine.yield();
				end
				isOver=true;
			else
				isPrint=true;
				local words="Sec_word";
				local message=subtitleData:GetCell(words,id);
				local words_data="";
				for temp in string.gmatch(message,"[%z\1-\127\194-\244][\128-\191]*") do

					if isPrint==false then
						words_data=message;
						text.Text=words_data;
						wait(0.05);
						break;
					end
					words_data=words_data..temp;
					text.Text=words_data;
					wait(0.05);
				end
				isPrint=false;
				coroutine.yield();
				isOver=true;
				
			end
		end);
		
		function Mouse_pressDown()
			if Input.GetPressKeyData(Enum.KeyCode.Mouse0) == Enum.KeyState.KeyStatePress then
			
				if coroutine.status(co1)=="suspended" and isPrint==false then
					coroutine.resume(co1);
				
				elseif coroutine.status(co1)=="suspended" and isPrint==true then
					isPrint=false;

				elseif coroutine.status(co1)=="dead" and isPrint==false then
					return;
				end
			end
		end
		
		
		Input.OnKeyDown:Connect(Mouse_pressDown);
		
		coroutine.resume(co1);
		
		while true do
			if isOver then
				break;
			end
			wait(0.1);
		end
		
		Input.OnKeyDown:Disconnect(Mouse_pressDown);
		
		PlayerController:SetDefault()
		PlayerController:SetDialogOn(false)

	end
	
return Subtitle
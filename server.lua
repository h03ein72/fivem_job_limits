ESX = nil
TriggerEvent('hos:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("job72_handler:setTime")
AddEventHandler("job72_handler:setTime", function(source, job_name, time)
	exports.ghmattimysql:execute("SELECT job_name FROM `job72_handler` WHERE job_name = @job_name", {
		['@job_name'] = tostring(job_name)
	}, function (result)
		if result[1] then
			if not time then
				exports.ghmattimysql:execute("UPDATE `job72_handler` SET expire_time = (NOW() + INTERVAL 0 DAY), limit_time = 0 WHERE job_name = @job_name", { 
					['@job_name'] = tostring(job_name)
				})
			else
				exports.ghmattimysql:execute("UPDATE `job72_handler` SET expire_time = (NOW() + INTERVAL @time DAY), limit_time = 1 WHERE job_name = @job_name", { 
					['@job_name'] = tostring(job_name),
					['@time'] = tonumber(time)
				})
			end
		else
			if not time then
				exports.ghmattimysql:execute("INSERT INTO `job72_handler` (job_name, limit_time, expire_time) VALUES (@job_name, 0, (NOW() + INTERVAL 0 DAY))", { 
					['@job_name'] = tostring(job_name),
					['@time'] = tonumber(time)
				})
			else
				exports.ghmattimysql:execute("INSERT INTO `job72_handler` (job_name, limit_time, expire_time) VALUES (@job_name, 1, (NOW() + INTERVAL @time DAY))", { 
					['@job_name'] = tostring(job_name),
					['@time'] = tonumber(time)
				})
			end	
		end
		if not time then
			TriggerClientEvent('hos:showNotification', source, "~g~Ba movafaghiat ~b~".. job_name .." ~g~be moddat ~b~Unlimited ~g~sabt shod.")
		else
			TriggerClientEvent('hos:showNotification', source, "~g~Ba movafaghiat ~b~".. job_name .." ~g~be moddat ~b~".. time .." ~g~ruz sabt shod.")
		end
	end)
end)

RegisterServerEvent("job72_handler:removeTime")
AddEventHandler("job72_handler:removeTime", function(source, job_name)
	exports.ghmattimysql:execute("SELECT * FROM `job72_handler` WHERE job_name = @job_name", {
		['@job_name'] = tostring(job_name)
	}, function (result)
		if result[1] then
			exports.ghmattimysql:execute("DELETE FROM `job72_handler` WHERE job_name = @job_name", {
				['@job_name'] = tostring(job_name)
			})
			TriggerClientEvent('hos:showNotification', source, "~g~Ba movafaghiat ~b~".. job_name .." ~r~hazf ~g~shod.")
		else
			TriggerClientEvent('hos:showNotification', source, "~r~Timer sabt nashode ast.")
		end
	end)
end)

RegisterServerEvent("job72_handler:getJobs")
AddEventHandler("job72_handler:getJobs", function(source, job_name, time)
	exports.ghmattimysql:execute("SELECT name FROM `jobs` WHERE name = @job_name", {
		['@job_name'] = tostring(job_name)
	}, function (result)
		if result[1] then
			TriggerEvent('job72_handler:setTime', source, tostring(job_name), time)
		else
			TriggerClientEvent('hos:showNotification', source, "~r~Job yaft nashod.")
		end
	end)
end)

ESX.RegisterServerCallback("job72_handler:getTimers", function(source, cb, job_name)
	exports.ghmattimysql:execute("SELECT * FROM `job72_handler` WHERE job_name = @job_name", {
		['@job_name'] = job_name
	}, function (result)
		if result[1] ~= nil then
			local expireTime = math.floor(result[1].expire_time/1000)
			local currentTime = os.time(os.date("!*t"))
			-- check if timer needed
			if result[1].limit_time == true then
				if expireTime < currentTime then
					cb(true)
				else
					cb(false)
				end
			-- bypass the timer and check only for slots
			elseif result[1].limit_time == false then
				cb(false)
			end
		else
			cb(true)
		end
	end)
end)

TriggerEvent('es:addAdminCommand', 'rtjob', 'admin', function(source, args, user)
	if args[1] and args[2] then
		if type(args[2]) == "string" and args[2] == "notime" then
			TriggerEvent('job72_handler:getJobs', source, tostring(args[1]), false)
		elseif type(tonumber(args[2])) == "number" then
			TriggerEvent('job72_handler:getJobs', source, tostring(args[1]), tonumber(args[2]))
		end
	else
		TriggerClientEvent('chatMessage', source, "[Job72]", {255, 0, 0}, "^0Arguments ^1failure ^0happened.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Set recharge time", params = {{name = "Job", help = "Enter your job name"}, {name = "Time", help = "Enter your day (number) or write notime (string)"}}})

TriggerEvent('es:addAdminCommand', 'rdjob', 'admin', function(source, args, user)
	if args[1] then
		TriggerEvent('job72_handler:removeTime', source, tostring(args[1]))
	else
		TriggerClientEvent('chatMessage', source, "[Job72]", {255, 0, 0}, "^0Arguments ^1failure ^0happened.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Delete mafia/gang recharge time", params = {{name = "Name", help = "Enter your mafia/gang name"}}})

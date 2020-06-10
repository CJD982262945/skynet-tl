local multicast = record
	MulticastConf = record
		channel: string
		dispatch: function(number, number, any)
	end

	MulticastChannel = record
		channel: string
		delete: function(MulticastChannel)
		publish: function(MulticastChannel, ...: any)
		subscribe: function(MulticastChannel)
		unsubscribe: function(MulticastChannel)
	end

	new: function(MulticastConf): MulticastChannel
end

return multicast
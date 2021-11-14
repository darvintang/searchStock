on run {receiver, message}
	tell application "Messages"
		send message to buddy receiver of (service 1 whose service type is iMessage)
	end tell
end run
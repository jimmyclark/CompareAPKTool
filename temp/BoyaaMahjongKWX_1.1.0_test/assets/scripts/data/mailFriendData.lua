local mailFriendData = class(require('data.dataList'))

addProperty(mailFriendData, "id", 		0)
addProperty(mailFriendData, "type", 	0)	
addProperty(mailFriendData, "sendtime", 0)	
addProperty(mailFriendData, "time", 	0)	
addProperty(mailFriendData, "money", 	0)
addProperty(mailFriendData, "sex", 		0)
addProperty(mailFriendData, "mnick", 	"")
addProperty(mailFriendData, "content", 	"")
addProperty(mailFriendData, "poto", 	"")

return mailFriendData
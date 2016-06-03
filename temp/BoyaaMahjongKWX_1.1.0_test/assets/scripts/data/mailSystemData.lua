local mailSystemData = class(require('data.dataList'))

addProperty(mailSystemData, "id", 	0)
addProperty(mailSystemData, "type", 	0)	
addProperty(mailSystemData, "award", 	0)	
addProperty(mailSystemData, "content", 	"")
addProperty(mailSystemData, "title", 	"")

return mailSystemData
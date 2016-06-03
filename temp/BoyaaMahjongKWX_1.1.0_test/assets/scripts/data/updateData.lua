local UpdateData = class(require('data.dataList'))

addProperty(UpdateData, "status", 0)
addProperty(UpdateData, "award", 0)
addProperty(UpdateData, "awardstr", "")
addProperty(UpdateData, "desc", "")
addProperty(UpdateData, "force", 0)
addProperty(UpdateData, "mode", 0)
addProperty(UpdateData, "title", "")
addProperty(UpdateData, "umeng", 0)
addProperty(UpdateData, "update", 0)
addProperty(UpdateData, "url", "")
addProperty(UpdateData, "verstr", "")

return UpdateData
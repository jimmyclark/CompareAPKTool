-- listView.lua
-- Author: Vicent.Gong
-- Date: 2012-09-27
-- Last modification : 2013-06-25
-- Description: Implemented listview 

require("core/object");
require("ui/tableView");

ListView = class(TableView);

ListView.setDefaultScrollBarWidth = function(width)
	ListView.s_scrollBarWidth = width or TableView.s_defaultScrollBarWidth;
end

ListView.setDefaultMaxClickOffset = function(maxClickOffset)
	ListView.s_maxClickOffset = maxClickOffset or TableView.s_defaultMaxClickOffset;
end

ListView.ctor = function(self, x, y, w, h)

end

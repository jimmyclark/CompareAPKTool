-- Node.lua
-- Author: Vicent Gong
-- Date: 2012-10-18
-- Last modification : 2012-10-22

require("core/object");
require("core/drawing");

Node = class(DrawingEmpty);

Node.ctor = function(self)
    self.m_tag = -1;
end

Node.dtor = function(self)
    
end
require("core/object");
require("core/constants");
require("core/anim");
require("core/prop");
require("core/system");
require("core/global");
require("libs/bit");

kRenderTriangles = 7;
kRenderDataTexture = 16;

AngleImage = class(DrawingBase);

AngleImage.s_defult_texCoord = {0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0};

AngleImage.ctor = function (self, fileName, width, height)
    self.m_imageResId = res_alloc_id();

    AngleImage.create(self, fileName, width, height);
end

-- @parameter 
-- x,y为img坐标上角位置
-- width, height: 可以不传
-- angle360: 倾斜角度 默认为0
AngleImage.create = function (self, fileName, width, height)
    res_create_image(0, self.m_imageResId, fileName, kRGBA8888, kFilterNearest);
    self.m_width = res_get_image_width(self.m_imageResId)
    self.m_height = res_get_image_height(self.m_imageResId)
    -- printInfo("width = %f, height = %f", self.m_width, self.m_height)
    drawing_create_node(0, self.m_drawingID, 0);
    drawing_set_node_renderable(self.m_drawingID, kRenderTriangles, kRenderDataTexture );
end

AngleImage.setAngle = function(self, angle, width, height, reverse)
    local function doCount(x, y, width, height, angle360, scale)
        x = x * System.getLayoutScale()
        y = y * System.getLayoutScale()
        width = width * System.getLayoutScale()
        height = height * System.getLayoutScale()
        local diff = height * math.tan(math.rad(angle360))
        return {
            x + diff / 2, y,
            x + diff / 2 + width, y,
            x + width - diff / 2, y + height,
            x - diff / 2, y + height
        }, reverse and 
        {
            1.0,1.0,
            0.0,1.0,
            0.0,0.0,
            1.0,0.0,
        }
        or {
            0.0,0.0,
            1.0,0.0,
            1.0,1.0,
            0.0,1.0,
        }
    end

    self:clearAngleResId()
    self.m_vertexResId = res_alloc_id();
    self.m_indexResId  = res_alloc_id();
    self.m_texCoordResId = res_alloc_id();
    self.m_angle = angle
    local t_vtx, t_tex_coord = doCount(0, 0, width or self.m_width, height or self.m_height, angle or self.m_angle360)
    local t_idx = {0,1,2,0,2,3};

    res_create_double_array2(0, self.m_vertexResId, t_vtx);
    res_create_ushort_array2(0, self.m_indexResId, t_idx);
    res_create_double_array2(0, self.m_texCoordResId, t_tex_coord);

    drawing_set_node_vertex(self.m_drawingID, self.m_vertexResId, self.m_indexResId);
    drawing_set_node_texture(self.m_drawingID, self.m_imageResId, self.m_texCoordResId);
    return self
end

AngleImage.clearAngleResId = function(self)
    if self.m_vertexResId then 
        res_delete(self.m_vertexResId);
        res_free_id(self.m_vertexResId);
        self.m_vertexResId = nil;
    end

    if self.m_indexResId then 
        res_delete(self.m_indexResId);
        res_free_id(self.m_indexResId);
        self.m_indexResId = nil;
    end

    if self.m_texCoordResId then 
        res_delete(self.m_texCoordResId);
        res_free_id(self.m_texCoordResId); 
        self.m_texCoordResId = nil;
    end
end

AngleImage.dtor = function (self)
    self:clearAngleResId()

    if self.m_imageResId then 
        res_delete(self.m_imageResId);
        res_free_id(self.m_imageResId);
        self.m_imageResId=nil;
    end

end

-- 如果img不是2的幂的话,调用此api得到最佳分辨率
AngleImage.getSuggestSize = function (self, origSize)
    if origSize and type(origSize) == "number" then
        local vSug = 1;
        while vSug < origSize do
             vSug = bit.blshift(vSug, 1);
        end
        return vSug;
    end
end

AngleImage.setFile = function(self, fileName)
    if self.m_imageResId then 
        res_delete(self.m_imageResId);
        res_free_id(self.m_imageResId);
        self.m_imageResId=nil;
    end

    self.m_imageResId = res_alloc_id();

    AngleImage.create(self, fileName, self.m_width, self.m_height);
    self:setAngle(self.m_angle or 0)
end
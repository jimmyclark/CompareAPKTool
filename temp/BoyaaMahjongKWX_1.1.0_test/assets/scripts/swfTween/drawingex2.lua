
DrawingBase.setMaskDrawing = function(self,mask)
	mask:setLevel(self.m_level);
	drawing_set_mask_drawing(self.m_drawingID,1,mask and mask.m_drawingID);
	drawing_set_program(mask.m_drawingID,"image2dMask",6);
end

DrawingBase.delMaskDrawing = function(self,mask)
	drawing_set_mask_drawing(self.m_drawingID,0,mask and mask.m_drawingID);
	drawing_set_program(mask.m_drawingID,"",6);
end

DrawingBase.setColorTransform = function(self,r,g,b,a,rOffest,gOffest,bOffest,aOffest)
	if self.m_color_id then
		res_delete(self.m_color_id);
   		res_free_id(self.m_color_id);
   		self.m_color_id = nil;
	end
	self.m_color_id = drawing_set_color_transform(self.m_drawingID,1,r,g,b,a,rOffest,gOffest,bOffest,aOffest)
end


function drawing_set_matrix(drawingID,matrix)
	drawing_set_force_matrix(drawingID,1,matrix);
end
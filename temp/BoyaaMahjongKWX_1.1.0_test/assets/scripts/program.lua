local PROGRAM_DATA_TYPE_ATTRIB = 1;
local PROGRAM_DATA_TYPE_UNIFORM = 2;
local PROGRAM_DATA_TYPE_TEXTURE = 3;
local PROGRAM_DATA_TYPE_INDEX = 4;

function createMirrorYAxisShader ()

    program_create("mirrorYAxisShader");

    local vsMirrorYAxis = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsMirrorYAxis = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vec2(vtexcoord.x, 1.0 - vtexcoord.y));
            gl_FragColor = color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorYAxisShader", vsMirrorYAxis, fsMirrorYAxis);

    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorYAxisShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
end


function createMirrorXAxisShader ()  

    program_create("mirrorXAxisShader");

    local vsMirrorXAxis = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsMirrorXAxis = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vec2(1.0 - vtexcoord.x, vtexcoord.y));
            gl_FragColor = color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorXAxisShader", vsMirrorXAxis, fsMirrorXAxis);

    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorXAxisShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
end

function createMirrorXYAxisShader ()

    program_create("mirrorXYAxisShader");

    local vsMirrorXYAxis = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
           gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
           vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsMirrorXYAxis = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        uniform vec2 sum;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vec2(1.0, 1.0) - vtexcoord);
            gl_FragColor = color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorXYAxisShader", vsMirrorXYAxis, fsMirrorXYAxis);

    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorXYAxisShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");

end

function createGrayScaleShader () 

    program_create("grayScaleShader");
    local vsGrayScale = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsGrayScale = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vtexcoord);
            float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
            gl_FragColor = vec4(gray, gray, gray, color.a) * u_color;
        }
    ]=];

    program_set_shader_source("grayScaleShader", vsGrayScale, fsGrayScale);

    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("grayScaleShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
end


function createBlurShaderVertical ()

    program_create("blurShaderVertical");

    local vsBlur = [=[
        uniform   mat4  u_mvp_matrix;
        uniform   float ratio;
        uniform   float height;
        attribute vec3  a_position;
        attribute vec2  a_tex_coord;
        varying   vec2  vtexcoord;
        varying   vec2  vblurtexcoord[9];

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord;
            vblurtexcoord[0] =  vtexcoord + vec2(0.0, -4.0/height) * ratio;
            vblurtexcoord[1] =  vtexcoord + vec2(0.0, -3.0/height) * ratio;
            vblurtexcoord[2] =  vtexcoord + vec2(0.0, -2.0/height) * ratio;
            vblurtexcoord[3] =  vtexcoord + vec2(0.0, -1.0/height) * ratio;
            vblurtexcoord[4] =  vtexcoord;
            vblurtexcoord[5] =  vtexcoord + vec2(0.0, 1.0/height) * ratio;
            vblurtexcoord[6] =  vtexcoord + vec2(0.0, 2.0/height) * ratio;
            vblurtexcoord[7] =  vtexcoord + vec2(0.0, 3.0/height) * ratio;
            vblurtexcoord[8] =  vtexcoord + vec2(0.0, 4.0/height) * ratio;
        }
    ]=];

    local fsBlur = [=[
        precision mediump float;
        uniform sampler2D texture2;
        uniform vec4 u_color;
        varying vec2 vtexcoord;
        varying vec2 vblurtexcoord[9];

        void main()
        {
            vec4 sample = vec4(0.0, 0.0, 0.0, 0.0);
            sample += texture2D(texture2, vblurtexcoord[0]) * u_color * 0.05;
            sample += texture2D(texture2, vblurtexcoord[1]) * u_color * 0.09;
            sample += texture2D(texture2, vblurtexcoord[2]) * u_color * 0.12;
            sample += texture2D(texture2, vblurtexcoord[3]) * u_color * 0.15;
            sample += texture2D(texture2, vblurtexcoord[4]) * u_color * 0.18;
            sample += texture2D(texture2, vblurtexcoord[5]) * u_color * 0.15;
            sample += texture2D(texture2, vblurtexcoord[6]) * u_color * 0.12;
            sample += texture2D(texture2, vblurtexcoord[7]) * u_color * 0.09;
            sample += texture2D(texture2, vblurtexcoord[8]) * u_color * 0.05;
            gl_FragColor = sample * u_color;
        }
    ]=];

    program_set_shader_source("blurShaderVertical", vsBlur, fsBlur);

    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_INDEX, 2, "index");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture2");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_UNIFORM, 1, "ratio");
    program_add_parameter("blurShaderVertical", PROGRAM_DATA_TYPE_UNIFORM, 1, "height");

end


function createBlurShaderHorizontal ()

    program_create("blurShaderHorizontal");

    local vsBlur = [=[
        uniform   mat4 u_mvp_matrix;
        uniform float ratio;
        uniform float width;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;
        varying   vec2 vblurtexcoord[5];

        void main()
        {
            gl_Position =  u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord =  a_tex_coord ;
            vblurtexcoord[0] =  vtexcoord + vec2( -3.230769/width, 0.0) * ratio;
            vblurtexcoord[1] =  vtexcoord + vec2( -1.384615/width, 0.0) * ratio;
            vblurtexcoord[2] =  vtexcoord;
            vblurtexcoord[3] =  vtexcoord + vec2( 1.384615/width, 0.0) * ratio;
            vblurtexcoord[4] =  vtexcoord + vec2( 3.230769/width, 0.0) * ratio;
        }
    ]=];

    local fsBlur = [=[
        precision mediump float;
        uniform sampler2D texture1;
        uniform vec4 u_color;
        varying vec2 vtexcoord;
        varying vec2 vblurtexcoord[5];

        void main()
        {
            lowp vec4 sample = vec4(0.0, 0.0, 0.0, 0.0);
            sample += texture2D(texture1, vblurtexcoord[0]) * 0.07027;
            sample += texture2D(texture1, vblurtexcoord[1]) * 0.316216;
            sample += texture2D(texture1, vblurtexcoord[2]) * 0.227027;
            sample += texture2D(texture1, vblurtexcoord[3]) * 0.316216;
            sample += texture2D(texture1, vblurtexcoord[4]) * 0.07027;
            gl_FragColor = sample * u_color ;
        }
    ]=];

    program_set_shader_source("blurShaderHorizontal", vsBlur, fsBlur);

    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_INDEX, 2, "index");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_UNIFORM, 1, "ratio");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_UNIFORM, 1, "width");
    program_add_parameter("blurShaderHorizontal", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture1");

end


function createMirrorYAtlasShader ()

    program_create("mirrorYAtlasShader");

    local vsMirrorYAtlas = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord;
        }
    ]=];

    local fsMirrorYAtlas = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        uniform float sum;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vec2(vtexcoord.x, sum - vtexcoord.y));
            gl_FragColor= color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorYAtlasShader", vsMirrorYAtlas, fsMirrorYAtlas);

    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
    program_add_parameter("mirrorYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 1, "sum");
end


function createMirrorXAtlasShader ()

    program_create("mirrorXAtlasShader");

    local vsMirrorXAtlas = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsMirrorXAtlas = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        uniform float sum;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, vec2(sum - vtexcoord.x, vtexcoord.y));
            gl_FragColor = color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorXAtlasShader", vsMirrorXAtlas, fsMirrorXAtlas);

    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
    program_add_parameter("mirrorXAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 1, "sum");
end

function createMirrorXYAtlasShader ()

    program_create("mirrorXYAtlasShader");

    local vsMirrorXYAtlas = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord;
        }
    ]=];

    local fsMirrorXYAtlas = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;
        uniform vec2 sum;
        varying vec2 vtexcoord;

        void main()
        {
            vec4 color = texture2D(texture0, sum - vtexcoord);
            gl_FragColor = color * u_color;
        }
    ]=];

    program_set_shader_source("mirrorXYAtlasShader", vsMirrorXYAtlas, fsMirrorXYAtlas);

    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_INDEX, 2, "index");
    program_add_parameter("mirrorXYAtlasShader", PROGRAM_DATA_TYPE_UNIFORM, 2, "sum");
end

local function createImage2dMask ()

    program_create("image2dMask");

    local vsImage2dMask = [=[
        uniform   mat4 mvpMatrix;
        attribute vec3 inPosition;
        attribute vec2 inTexCoord;
        varying   vec2 varyTexCoord;

        void main()
        {
            gl_Position = mvpMatrix * vec4(inPosition, 1.0);
            varyTexCoord = inTexCoord ;
        }
    ]=];

    local fsImage2dMask = [=[
        precision mediump float;
        uniform sampler2D texture;
        uniform vec4 color;
        
        varying vec2 varyTexCoord;

        void main()
        {   
            vec4 colorT = texture2D(texture, varyTexCoord); 
            colorT = colorT * color; 
            if (colorT.a == 0.0)  
                {discard;}                        
            else
                gl_FragColor = colorT;
        }
    ]=];

    program_set_shader_source("image2dMask", vsImage2dMask, fsImage2dMask);

    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("image2dMask", PROGRAM_DATA_TYPE_INDEX, 2, "index");
end

function createImage2dColor ()

    program_create("image2dColor");

    local vsImage2dColor = [=[
        uniform   mat4 u_mvp_matrix;
        attribute vec3 a_position;
        attribute vec2 a_tex_coord;
        varying   vec2 vtexcoord;

        void main()
        {
            gl_Position = u_mvp_matrix * vec4(a_position, 1.0);
            vtexcoord = a_tex_coord ;
        }
    ]=];

    local fsImage2dColor = [=[
        precision mediump float;
        uniform sampler2D texture0;
        uniform vec4 u_color;  
        uniform vec4 o_color;   
        varying vec2 vtexcoord;

        void main()
        {   
            vec4 color = texture2D(texture0, vtexcoord);           
            vec4 r_color = color * u_color + vec4(o_color.xyz / 255.0, o_color.a) * color.a;
			if(r_color.a < 0.01)
			{
			    discard;
			}
			else
            gl_FragColor = clamp(r_color,0.0,1.0);
        }
    ]=];

    program_set_shader_source("image2dColor", vsImage2dColor, fsImage2dColor);

    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_UNIFORM, 44, "u_mvp_matrix");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_ATTRIB, 3, "a_position");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_TEXTURE, 0, "texture0");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_ATTRIB, 2, "a_tex_coord");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_UNIFORM, 4, "u_color");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_UNIFORM, 4, "o_color");
    program_add_parameter("image2dColor", PROGRAM_DATA_TYPE_INDEX, 2, "index");
end


function create_program ()
    createGrayScaleShader();
    createMirrorXAxisShader();
    createMirrorYAxisShader();
    createMirrorXYAxisShader();
    createBlurShaderVertical();
    createBlurShaderHorizontal();
    createMirrorXAtlasShader();
    createMirrorYAtlasShader();
    createMirrorXYAtlasShader();
    createImage2dMask()
    createImage2dColor()
end


create_program();

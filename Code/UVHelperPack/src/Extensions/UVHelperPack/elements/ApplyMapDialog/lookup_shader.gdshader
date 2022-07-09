// Authored by Variable (6 May 2022)
shader_type canvas_item;

uniform sampler2D map_texture;  // The map texture
uniform vec2 map_size = vec2(64, 64);  // The size of the map image
// (i wanted to use textureSize() but its only supported for GLES3)

// Useage:
// Apply this shader to the base texture
// the r and g values (0-255) of base image will be concidered as coordinates
// Color from the "map_tex" will then be picked at the given coordinates
// And displayed here
void fragment(){
    COLOR = vec4(0.0);
    vec4 col = texture(TEXTURE, UV);
    vec2 lookup_uv = vec2(round(col.x * 255.0)/(map_size.x - 0.1), round(col.y * 255.0)/(map_size.y - 0.1));
    vec4 tex = texture(map_texture, lookup_uv);
    
    if (col.a > 0.0) {
    COLOR = tex;
    }
}

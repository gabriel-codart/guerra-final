shader_type canvas_item;

uniform float blur_size: hint_range(0.0, 2.5) = 0.0;
uniform sampler2D SCREEN_TEXTURE : filter_linear_mipmap,hint_screen_texture;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, blur_size);
	COLOR = color;
}
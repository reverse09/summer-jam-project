shader_type canvas_item;



uniform vec2 refractionOffset = vec2(25.0f, 25.0f);

uniform vec2 reflectionOffset = vec2(1.0f, 1.0f);

uniform vec4 reflectionColor : source_color = vec4(1.0f, 1.0f, 1.0f, 0.8f);

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;



const vec4 WHITE = vec4(1.0f);



void fragment() {

	COLOR = texture(TEXTURE, UV);

	vec4 adjacentColor = texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * reflectionOffset);

	if (COLOR != WHITE)

		discard;

	if (adjacentColor != WHITE)

		COLOR = reflectionColor;

	else

		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * refractionOffset );

}
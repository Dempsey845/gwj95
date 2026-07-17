shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform vec4 fill_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    if (UV.y < (1.0 - progress)) {
        color.a = 0.0;
    }

    COLOR = color * fill_color;
}
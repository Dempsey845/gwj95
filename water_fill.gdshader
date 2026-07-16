shader_type canvas_item;

uniform float fill : hint_range(0.0, 1.0) = 0.5;

uniform vec4 water_color : source_color = vec4(0.15, 0.45, 1.0, 1.0);
uniform vec4 water_dark : source_color = vec4(0.05, 0.2, 0.65, 1.0);
uniform vec4 bubble_color : source_color = vec4(0.85, 0.95, 1.0, 1.0);
uniform vec4 foam_color : source_color = vec4(0.95, 1.0, 1.0, 1.0);

uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);

uniform float wave_height = 0.015;
uniform float wave_speed = 3.0;
uniform float wave_frequency = 35.0;

uniform float bubble_amount = 35.0;
uniform float bubble_speed = 0.15;
uniform float bubble_size = 0.012;


float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}


void fragment() {
	vec2 resolution = vec2(320.0, 240.0);
	vec2 uv = floor(UV * resolution) / resolution;

	COLOR = background_color;

	float surface = 1.0 - fill;

	// Wobbly surface
	float wave = sin(
		uv.x * wave_frequency + TIME * wave_speed
	) * wave_height;

	surface += wave;


	if (uv.y > surface) {

		// Water depth gradient
		float depth = (uv.y - surface) / fill;

		COLOR = mix(
			water_color,
			water_dark,
			depth
		);


		// Moving water shine
		float shine = sin(
			uv.x * 25.0 + TIME * 2.0
		);

		if (shine > 0.85) {
			COLOR.rgb += 0.04;
		}


		// Foam line at surface
		float edge = abs(uv.y - surface);

		if (edge < 0.015) {

			float foam = hash(vec2(
				floor(uv.x * 40.0),
				floor(TIME * 4.0)
			));

			if (foam > 0.5) {
				COLOR = foam_color;
			}
		}


		// Rising bubbles
		vec2 grid = uv * bubble_amount;

		vec2 cell = floor(grid);
		vec2 pos = fract(grid);


		vec2 bubble_pos = vec2(
			hash(cell),
			hash(cell + 10.0)
		);


		// Bubble movement upwards
		bubble_pos.y = fract(
			bubble_pos.y - TIME * bubble_speed
		);


		float bubble_dist = distance(
			pos,
			bubble_pos
		);


		if (bubble_dist < bubble_size) {

			float highlight = step(
				bubble_size * 0.45,
				bubble_dist
			);

			COLOR = mix(
				bubble_color,
				foam_color,
				highlight
			);
		}
	}
}
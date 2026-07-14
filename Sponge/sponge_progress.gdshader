shader_type canvas_item;

uniform float water_level : hint_range(0.0, 1.0) = 0.5;

// Sponge colours
uniform vec4 sponge_color : source_color = vec4(1.0, 0.8588, 0.3020, 1.0);
uniform vec4 hole_color   : source_color = vec4(0.705, 0.635, 0.102, 1.0); 

// Water
uniform vec4 water_tint : source_color = vec4(0.08, 0.45, 0.95, 1.0);
uniform float wet_darkness : hint_range(0.0,1.0) = 0.35;


// Sponge holes
uniform float hole_density = 8.0;
uniform float hole_radius = 0.23;


// Waves
uniform float wave_height = 0.015;
uniform float wave_speed = 1.6;
uniform float wave_frequency = 8.0;


// Bubbles
uniform int bubble_count = 10;


float rand(vec2 p)
{
	return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453);
}

void fragment()
{
	vec2 uv = floor(UV * vec2(64.0, 128.0)) / vec2(64.0, 128.0);
	vec4 col = sponge_color;


	vec2 grid = uv * hole_density;

	vec2 cell = floor(grid);
	vec2 local = fract(grid);


	vec2 centre = vec2(
		rand(cell),
		rand(cell + 8.3)
	);


	float radius = hole_radius * 
		(0.6 + rand(cell + 3.1) * 0.6);


	if(distance(local, centre) < radius)
	{
		col = hole_color;
	}

	float wave = sin(
		uv.x * wave_frequency + TIME * wave_speed
	) * wave_height;


	float surface = 1.0 - water_level + wave;


	bool underwater = uv.y > surface;

	if(underwater)
	{
		// Dark wet sponge
		vec3 wet = col.rgb * (1.0 - wet_darkness);

		// Strong blue water overlay
		col.rgb = mix(
			wet,
			water_tint.rgb,
			0.65
		);


		// slight water brightness
		col.rgb += vec3(0.02,0.05,0.1);
	}

	if(abs(uv.y - surface) < 0.01)
	{
		col.rgb = mix(
			col.rgb,
			vec3(0.75,0.95,1.0),
			0.8
		);
	}

	if(underwater)
	{
		for(int i = 0; i < 10; i++)
		{
			float fi = float(i);

			vec2 seed = vec2(
				fi * 7.13,
				fi * 3.21
			);


			float x = rand(seed);


			float speed = 
				0.12 + rand(seed + 1.2) * 0.18;


			float size =
				0.006 + rand(seed + 2.3) * 0.01;


			float y =
				fract(TIME * speed + rand(seed + 5.2));


			vec2 bubble_pos = vec2(
				x,
				1.0 - y
			);

			if(distance(uv,bubble_pos) < size)
			{
				col.rgb = mix(
					col.rgb,
					vec3(0.85,0.95,1.0),
					0.8
				);
			}
		}
	}

	COLOR = col;
}
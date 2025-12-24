shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float vignette_strength;
uniform float blur_strength;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 original_color = texture(SCREEN_TEXTURE, uv);
	vec4 color = original_color;
	
	//легкое размытие только по бокам
	if (blur_strength > 0.0) {
		//сила размытия увеличивается к краям
		float edge_factor = abs(uv.x - 0.5) * 2.0; // 0 в центре, 1 по краям
		float current_blur = blur_strength * edge_factor * edge_factor * 0.003; //слабое размытие
		
		if (current_blur > 0.0001) {
			vec4 blur_color = vec4(0.0);
			float total_weight = 0.0;
			int samples = 4;
			
			for (int i = -samples; i <= samples; i++) {
				float offset_x = float(i) * current_blur;
				vec2 offset = vec2(offset_x, 0.0);
				float weight = 1.0 - abs(float(i)) / float(samples);
				blur_color += texture(SCREEN_TEXTURE, uv + offset) * weight;
				total_weight += weight;
			}
			
			vec4 final_blur = blur_color / total_weight;
			
			// Очень плавное смешивание - всего 30% размытия даже на максимуме
			float blend = smoothstep(0.0, 0.3, edge_factor * blur_strength);
			color = mix(original_color, final_blur, blend);
		}
	}
	
	//легкая виньетка по бокам (легкое затемнение)
	float horizontal_vignette = abs(uv.x - 0.5) * 2.0;
	float vignette = 1.0 - horizontal_vignette * vignette_strength * 0.3; //очень слабая виньетка
	vignette = clamp(vignette, 0.7, 1.0);
	
	color.rgb *= vignette;
	COLOR = color;
}

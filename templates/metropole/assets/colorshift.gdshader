shader_type canvas_item;

uniform vec3 color;
const float threshold = 0.8;

void fragment() {
	if (dot(COLOR.rgb,vec3(1,1,1)) > threshold) { //Ensure colour is within threshold to manage compression artefacts.
		COLOR.rgb = color;
	}
}

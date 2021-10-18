shader_type canvas_item;

uniform float PI = 3.14159265359;
uniform float height : hint_range(0.0, 1.0) = 0.6;
uniform float width : hint_range(0.0, 2.0) = 1.5;
uniform float maximumOpacity = 0.5;

float circle(vec2 uv, float radius, float blur) {
	float d = length(uv);
	float c = smoothstep(radius, radius - blur, d);
	return c;
}

void fragment(){
	vec2 uv = UV;
	float diameter = 1.0;
	float blur = 0.1;
	float c1 = circle(uv - 0.5, diameter/2., blur);
	
	COLOR = vec4(vec3(0,1,0), c1*maximumOpacity);
}
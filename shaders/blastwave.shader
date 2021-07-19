shader_type canvas_item;
uniform float PI = 3.14159265359;
uniform float height : hint_range(0.0, 1.0) = 0.3;
uniform float time_to_height = 0.6;
uniform float color_change_time = 0.3;
uniform float alpha_change_time = 0.4;
uniform float current_time : hint_range(0., 1.)= 0.0;
uniform vec4 color_start : hint_color;
uniform vec4 color_mix : hint_color;
uniform vec4 color_end : hint_color;
uniform float width_ratio = 1.2;

float ellipse(vec2 st, vec2 center, vec2 radii){
  //x^2 / rx^2 + y^2 / ry^2 = 1
  vec2 pos = st - center;
  vec2 pos2 = pos*pos;
  vec2 radii2 = radii*radii;
  return 1. - smoothstep(0.8, 1., pos2.x / radii2.x + pos2.y / radii2.y);

}

//https://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand_range(in vec2 st, in float val){
  float r = rand(st);
  return r*val;
}

float easeOutSine(in float x){
  return sin((x * PI) / 2.);
}

float inverseEaseOut(in float weight){
  return 2.0*asin(weight) / PI;
}

float invLerp(float from, float to, float value){
  return (value - from) / (to - from);
}


void fragment(){
    float height_progress = easeOutSine(min(current_time / time_to_height, 1.0));
    float pct = 0.0;
    float h = mix(0.0, height, height_progress);
    vec2 origin = vec2(0.5, 1.0);
    origin.y -= h;
    vec2 radii = vec2(width_ratio*h, h);
    pct = ellipse(UV, origin, radii);
    
    float t_c_change = rand_range(UV, color_change_time);
    float t_a_change = rand_range(UV, alpha_change_time);
    float exist_time = current_time - inverseEaseOut(invLerp(0.0, 2.*h, -UV.y + 1.)) * time_to_height;
    float color_mix_weight = clamp(exist_time/t_c_change, 0.0, 1.0);
    float alpha_mix_weight = clamp(exist_time/t_a_change, 0.0, 1.0);
    vec3 color = mix(color_start.rgb, color_mix.rgb, rand(UV));
    color = mix(color, color_end.rgb, color_mix_weight);
    float alpha = mix(1.0, 0.0, alpha_mix_weight);
    COLOR = vec4(color * (1. - color_mix_weight)*3., alpha*pct);
}
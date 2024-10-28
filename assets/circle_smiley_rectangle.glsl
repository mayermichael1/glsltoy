#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;
uniform vec4    iMouse;

float circle(vec2 uv, vec2 position, float r, float blur){
    float d = length(uv - position);
    return smoothstep(r, r - blur, d);
}

float smiley(vec2 uv, vec2 position, float size){

    uv -= position; // translate coordinate system
    uv /= size;

    float face = circle(uv, vec2(0.0), 0.4, 0.01);
    face -= circle(uv, vec2(-0.13, +0.20), 0.07, 0.01);
    face -= circle(uv, vec2(+0.13, +0.20), 0.07, 0.01);

    float mouth = circle(uv, vec2(0.0, 0.0), 0.3, 0.02);
    mouth -= circle(uv, vec2(0.0, +0.1), 0.3, 0.02);

    return face - mouth;
}

float band(float t, float start, float end, float blur){
    float mask = 0;
    mask = smoothstep(start-blur, start+blur, t);
    mask *= smoothstep(end+blur, end-blur, t);
    return mask;
}

float rectangle(vec2 uv, float left, float top, float right, float bottom, float blur){
    float mask = 1.0;
    mask = band(uv.x, left, right, blur);
    mask *= band(uv.y, top, bottom, blur);
    return mask;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= 0.5f;
    uv.x *= iResolution.x / iResolution.y;

    vec3 color = vec3(1.0f, 1.0f, 0.0f);
    //color *= smiley(uv, vec2(0.0), 1.0);
    color *= rectangle(uv, -0.25, -0.25, 0.25, 0.25, 0.001);

    fragColor = vec4(color, 1.0f);
}


void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


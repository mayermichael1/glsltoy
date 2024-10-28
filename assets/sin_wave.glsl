#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;
uniform vec4    iMouse;

const float PI = 3.1415926;
const float freq = PI * 2.0;
const float amplitude = 0.4;
const float speed = 0.2;

float f(float x){
    return sin((x + iTime * speed) * freq) * amplitude;
}

float df(float x){
    return cos((x + iTime * speed) * freq) * amplitude * freq;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv.y -= 0.5;
    uv.x *= iResolution.x / iResolution.y;
    
    // sin
    vec3 color = vec3(1.0, 0.0, 0.0);
    float d = abs(uv.y - f(uv.x));
    d /= sqrt(1.0 + df(uv.x) * df(uv.x));
    d = 1.0 - d;
    d = pow(d, 32.0);
    color *= d;
    
    // differentiated sin
    //vec3 color2 = vec3(0.0, 1.0, 0.0);
    //float dd = abs(uv.y - df(uv.x));
    //dd = step(0.01, dd);
    //dd = 1.0 - dd;
    //color2 *= dd;
    //color += color2;
    
    // base line y = 0
    vec3 lineColor = vec3(0.0, 1.0, 0.0);
    float dy = abs(uv.y);
    dy = step(0.002, dy);
    dy = 1.0 - dy;
    if( dy >= 1.0){
        color = lineColor;
    }

    // Output to screen
    fragColor = vec4(color,1.0);
}

void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


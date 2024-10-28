#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;
uniform vec4    iMouse;
#define NUM_LAYERS 8.0

mat2 rotate(float a){
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

float star(vec2 uv, float flare){
    float d = length(uv);
    float m = 0.05 / d;
    
    float rays = max(0.0, 1.0-abs(uv.x * uv.y * 1000.0));
    m += rays * flare;
    
    uv *= rotate(3.1415/4.0);
    
    float rays2 = max(0.0, 1.0-abs(uv.x * uv.y * 1000.0));
    m += rays2 * 0.3 * flare;
    
    m *= smoothstep(1.0, 0.2, d);
    
    return m;
}

float hash21(vec2 p){
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x * p.y);
}

vec3 starLayer(vec2 uv){
    vec3 col = vec3(0);
    
    vec2 gv = fract(uv) - 0.5;
    vec2 id = floor(uv);
    
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            vec2 offset = vec2(x, y);
            
            float n = hash21(id + offset); // pseudo random number between 0 and 1
            float size = fract(n*345.32);
            float starValue = star((gv-offset)-(vec2(n, fract(n*34.0))-0.5), smoothstep(0.9, 1.0, size)*.06);
            
            vec3 color = sin(vec3(0.2, 0.3, 0.9) * fract(n*2345.2) * 123.2) * 0.5 + 0.5;
            color = color * vec3(1.0, 0.2, 1.0+size);
            
            starValue *= sin(iTime * 3.0 + n * 6.2831)*0.5+0.5;
            
            col += starValue * size * color;
        }
    }  
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){

    vec2 uv = (fragCoord-0.5 * iResolution.xy) / iResolution.y;
    vec2 mouse = (iMouse.xy-0.5 * iResolution.xy) / iResolution.y;
    
    vec3 col = vec3(0.0);
    float t = iTime * 0.05;
    
    uv += mouse * 4.0;
    uv *= rotate(t);
    
    for(float i=0.0; i<1.0; i+=1.0/NUM_LAYERS){
        float depth = fract(i+t);
        float scale = mix(20.0, 0.5, depth);
        float fade = depth * smoothstep(1.0, 0.9, depth);
        col += starLayer(uv * scale + i*453.2) * fade;
    }
    
    //if(gv.x>0.48 || gv.y >0.48) col.r = 1.0;
    
    fragColor = vec4(col,1.0);
}

void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


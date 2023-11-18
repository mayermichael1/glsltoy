#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
}

void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


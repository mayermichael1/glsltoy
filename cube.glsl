#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;
uniform vec4    iMouse;

float distLine(vec3 rayOrigin, vec3 rayDirection, vec3 point){
    float distance = 0.0f;

    distance = length(cross(point - rayOrigin, rayDirection));
    distance /= length(rayDirection);

    return distance;
}

float drawPoint(vec3 rayOrigin, vec3 rayDirection, vec3 p){
    float d = distLine(rayOrigin, rayDirection, p);
    return smoothstep(0.06, 0.05, d);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv -= 0.5f;
    uv.x *= iResolution.x / iResolution.y;
    
    vec3 rayOrigin = vec3(5 * sin(iTime), 0.0f, 5 * cos(iTime));
    vec3 lookAt = vec3(0.5f, 0.5f, 0.5f);
    float zoom = 1.0f;

    vec3 camFront = normalize(lookAt - rayOrigin);
    vec3 camRight = cross(vec3(0.0, 1.0, 0.0), camFront);
    vec3 camUp = cross(camRight, camFront);
    
    vec3 center = rayOrigin + camFront * zoom;
    vec3 intersectPoint =  center + uv.x * camRight + uv.y * camUp;

    vec3 rayDirection = intersectPoint - rayOrigin;
    
    float d = 0;
     
    d += drawPoint(rayOrigin, rayDirection, vec3(0.0, 0.0, 0.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(0.0, 0.0, 1.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(0.0, 1.0, 0.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(0.0, 1.0, 1.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(1.0, 0.0, 0.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(1.0, 0.0, 1.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(1.0, 1.0, 0.0));
    d += drawPoint(rayOrigin, rayDirection, vec3(1.0, 1.0, 1.0));

    fragColor = vec4(vec3(d), 1.0f);
}


void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


#version 330 core
out vec4 FragColor;

uniform vec3    iResolution;
uniform float   iTime;
uniform vec4    iMouse;

float drawPoint(vec2 uv, vec2 offset, float radius){
    uv -= offset;
    float intensity = length(vec2(uv.x, uv.y));
    intensity = smoothstep(radius, radius * 1.1, intensity);
    intensity = 1 - intensity;
    return intensity;
}

float distanceLineToPoint(vec3 camPosition, vec3 rayDirection, vec3 point){
    vec3 pointDirection = point - camPosition;
    float distance = length(cross(pointDirection, rayDirection)) / length(rayDirection);

    return distance;
}

vec3 getScreenIntersect(vec3 camPosition, vec3 screenPosition, vec2 uv, vec3 camUp, vec3 camRight){
    vec3 screenIntersect = screenPosition;
    //screenIntersect.x += uv.x;
    //screenIntersect.y += uv.y;
    screenIntersect += camUp * uv.y;
    screenIntersect += camRight * uv.x;
    return screenIntersect;
}

vec3[8] moveCube(vec3[8] corners, vec3 moveBy){
    for(int i = 0; i < 8; i++){
        corners[i] -= moveBy;
    }
    return corners;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
    uv.x *= iResolution.x / iResolution.y;

    // fixed camera
    //vec3 camPosition = vec3(0.0, 0.0, 10.0);

    //vec3 screenPosition = vec3(0.0, 0.0, 5.0);
    //vec3 screenIntersect = getScreenIntersect(camPosition, screenPosition, uv);

    //vec3 rayDirection = screenIntersect - camPosition;
    //
    vec3 camPosition = vec3(0.0, 3.0, 10.0);

    camPosition.x = 10.0 * sin(iTime);
    camPosition.z = 10.0 * cos(iTime);
    camPosition.y = 0.0;
    //camPosition.x = 10.0;
    //camPosition.z = 0.0;
    //camPosition.y = 5.0 * sin(iTime * 0.5);

    vec3 lookAt = vec3(0.0, 0.0, 0.0);
    vec3 camFront = normalize(lookAt - camPosition);
    vec3 camRight = normalize(cross(camFront, vec3(0.0, 1.0, 0.0)));
    vec3 camUp = normalize(cross(camFront, camRight));

    float screenDistance = 3.0;
    vec3 screenPosition = camPosition - screenDistance * camFront;

    vec3 screenIntersect = getScreenIntersect(camPosition, screenPosition, uv, camUp, camRight); 

    vec3 rayDirection = screenIntersect - camPosition;

    vec3 corners[8] = vec3[8](
        vec3(0.0f, 0.0f, 0.0f),
        vec3(0.0f, 0.0f, 1.0f),
        vec3(0.0f, 1.0f, 0.0f),
        vec3(0.0f, 1.0f, 1.0f),
        vec3(1.0f, 0.0f, 0.0f),
        vec3(1.0f, 0.0f, 1.0f),
        vec3(1.0f, 1.0f, 0.0f),
        vec3(1.0f, 1.0f, 1.0f)
    );
    for(int i = 0; i < 8; i++){
        corners[i] += vec3(-0.5f, -0.5f, -0.5);
    }

    float intensity = 0.0;
    for(int i = 0; i < 8; i++){
        float distance = distanceLineToPoint(camPosition, rayDirection, corners[i]); 

        distance = smoothstep(0.05, 0.055, distance);
        distance = 1 - distance;

        intensity += distance;
    }

    fragColor = vec4(1.0f, 1.0f, 1.0f, 1.0f) * intensity;
}


void main(){
    vec4 fragColor = vec4(0.0f);

    mainImage(fragColor, gl_FragCoord.xy);

    FragColor = fragColor;
}


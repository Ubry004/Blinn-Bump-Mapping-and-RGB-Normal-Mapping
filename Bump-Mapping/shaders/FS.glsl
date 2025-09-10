#version 330 core

out vec4 FragColor;

in VS_OUT {
    vec3 FragPos;
    vec2 UV;
    mat3 TBN;
} fs_in;

uniform sampler2D heightMap;  // grayscale bump map
uniform sampler2D normalMap;  // RGB normal map
uniform vec3 lightPos;
uniform vec3 viewPos;
uniform int useModern;        // 0 = bump map, 1 = normal map

// Simple Blinn-Phong lighting
vec3 blinnPhong(vec3 normal, vec3 fragPos, vec3 lightPos, vec3 viewPos) {
    vec3 lightDir = normalize(lightPos - fragPos);
    vec3 viewDir = normalize(viewPos - fragPos);

    // Diffuse
    float diff = max(dot(normal, lightDir), 0.0);

    // Specular
    vec3 halfDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfDir), 0.0), 32.0);

    vec3 color = vec3(0.3, 0.5, 0.8); // base color
    vec3 ambient = 0.1 * color;
    vec3 diffuse = diff * color;
    vec3 specular = spec * vec3(1.0);

    return ambient + diffuse + specular;
}

void main() {
    vec3 normal;

    if (useModern == 0) {
        // === Classic Bump Mapping ===
        float h = texture(heightMap, fs_in.UV).r;

        // Derivatives of height in screen-space
        float h_dx = dFdx(h);
        float h_dy = dFdy(h);

        // Approximate perturbed normal
        normal = normalize(fs_in.TBN[2] - h_dx * fs_in.TBN[0] - h_dy * fs_in.TBN[1]);
    } else {
        // === Normal Mapping ===
        vec3 n = texture(normalMap, fs_in.UV).rgb;
        n = normalize(n * 2.0 - 1.0); // from [0,1] → [-1,1]
        normal = normalize(fs_in.TBN * n);
    }

    vec3 result = blinnPhong(normal, fs_in.FragPos, lightPos, viewPos);
    FragColor = vec4(result, 1.0);
}

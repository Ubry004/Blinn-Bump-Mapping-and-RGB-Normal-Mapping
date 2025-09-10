#version 330 core

layout(location = 0) in vec3 inPos;    // Sphere vertex position
layout(location = 1) in vec3 inNormal; // Sphere vertex normal
layout(location = 2) in vec2 inUV;     // Sphere texture coordinates
layout(location = 3) in vec3 inTangent;// Tangent vector (precomputed per vertex)

out VS_OUT {
    vec3 FragPos;
    vec2 UV;
    mat3 TBN;
} vs_out;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    // World position
    vec4 worldPos = model * vec4(inPos, 1.0);
    vs_out.FragPos = worldPos.xyz;

    vs_out.UV = inUV;

    // Build TBN basis
    vec3 N = normalize(mat3(model) * inNormal);
    vec3 T = normalize(mat3(model) * inTangent);
    vec3 B = normalize(cross(N, T));
    vs_out.TBN = mat3(T, B, N);

    gl_Position = projection * view * worldPos;
}

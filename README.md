You can simulate high-detail surfaces on low-polygon 3D models using normal maps and height maps! Thanks Jim Blinn :)

By manipulating surface normals per pixel, we can create the illusion of depth, bumps, and fine details without increasing geometric complexity, making real-time rendering more efficient.

Blinn's paper: https://dl.acm.org/doi/10.1145/965139.507101

Swap between techniques using B

# Techniques Used
1. Height Maps
- Grayscale textures representing surface elevation; black is high, white is low.
- Traditionally used for bump mapping and displacement mapping. Height maps provide the base information to compute surface perturbations.

Basically you can do this without having to model each bump! This reduces memory and computational costs.

2. Normal Maps
- RGB textures storing per-pixel normal vectors; red, green, and blue channels correspond to X, Y, Z components of the normal.
- Transform normals relative to the surface, enabling correct lighting on arbitrary geometry.
- Applied in the fragment shader to modify per-pixel lighting, creating realistic surface detail.

This is the modern approach. Provides visually rich surfaces in real-time graphics, which is pretty important for modern games and simulations.

3. Integration in Shaders
Height maps can generate the normal perturbations (see Blinn's paper), but modern pipelines often use precomputed RGB normal maps for performance.
Shaders combine vertex normals with normal map data to compute lighting using per-pixel Blinn-Phong shading.

There's an evolution from Blinn’s bump mapping (1978), which perturbed normals based on height, to modern RGB tangent-space normal maps. You can see the difference in the gif below.

# DEMO

![](DEMO_B.gif)

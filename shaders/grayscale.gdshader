shader_type canvas_item;

uniform float line_thickness : hint_range(0.0, 10.0) = 1.0;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // Get the original texture color
    vec4 original = texture(TEXTURE, UV);

    // Create basic noise pattern for sketch lines
    vec2 uv = UV * 256.0;
    float noise = random(floor(uv));

    // Edge detection using surrounding pixels
    vec2 pixel_size = TEXTURE_PIXEL_SIZE * line_thickness;
    vec4 up = texture(TEXTURE, UV + vec2(0.0, -pixel_size.y));
    vec4 down = texture(TEXTURE, UV + vec2(0.0, pixel_size.y));
    vec4 left = texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0));
    vec4 right = texture(TEXTURE, UV + vec2(pixel_size.x, 0.0));

    // Calculate edges
    float edges = abs(up.r - down.r) + abs(left.r - right.r);

    // Convert to grayscale
    float gray = dot(original.rgb, vec3(0.499, 0.587, 0.114));
    vec4 grayscale = vec4(vec3(gray), original.a);

    // Combine effects
    float sketch = mix(1.0, noise, noise_strength);
    sketch = mix(sketch, 0.0, edges * 2.0);

    // Final color with original alpha
    vec4 final_color = mix(grayscale, line_color, (1.0 - sketch));
    COLOR = vec4(final_color.rgb, original.a);
}
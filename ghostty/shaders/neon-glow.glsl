// Neon glow / bloom shader for Ghostty
// Shadertoy-compatible: iChannel0 = terminal screen contents.
// Extracts the bright parts of the rendered text and blooms them
// outward so glyphs appear to glow like neon tubing.

float gaussian(vec2 i, float sigma) {
    return exp(-0.5 * dot(i /= sigma, i)) / (6.2831853 * sigma * sigma);
}

// Push a color away from its luminance to keep the glow vividly tinted
// instead of fading toward gray/white.
vec3 boostSaturation(vec3 c, float amount) {
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(vec3(luma), c, amount);
}

vec3 bloomBlur(sampler2D tex, vec2 uv, vec2 texel, float sigma) {
    vec3 col = vec3(0.0);
    float total = 0.0;
    const int K = 5; // kernel radius -> (2K+1)^2 taps
    for (int x = -K; x <= K; x++) {
        for (int y = -K; y <= K; y++) {
            vec2 o = vec2(float(x), float(y));
            float w = gaussian(o, sigma);
            col += texture(tex, uv + o * texel).rgb * w;
            total += w;
        }
    }
    return col / total;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 texel = 1.0 / iResolution.xy;

    vec3 original = texture(iChannel0, uv).rgb;

    // Blur the whole screen, then keep only the bright regions so the
    // background stays dark and only text/cursor contribute to the glow.
    vec3 blurred = bloomBlur(iChannel0, uv, texel, 2.5);
    float threshold = 0.25;
    vec3 glow = max(blurred - threshold, 0.0);

    // Intensity of the neon halo. Bump this up for a stronger glow.
    float strength = 0.9;
    glow *= strength;

    // Keep the halo vividly colored so it reads as neon rather than
    // washing the underlying text toward white.
    glow = boostSaturation(glow, 1.5);

    // Screen blend instead of a straight add: rolls highlights off softly
    // and never clips a channel past 1.0, so colors stay saturated.
    vec3 result = 1.0 - (1.0 - original) * (1.0 - clamp(glow, 0.0, 1.0));

    fragColor = vec4(result, 1.0);
}

Shader "Custom/PointSurface"
{
    Properties {
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface ConfigureSurface Standard fullforwardshadows
        #pragma target 3.0  // Use shader model 3.0 target, to get nicer looking lighting

        struct Input
        {
            float3 worldPos;
        };

        float _Smoothness;

        float3 hsv2rgb(float3 c)
        {
            float4 K = float4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
            float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
            return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
        }

        void ConfigureSurface (Input input, inout SurfaceOutputStandard surface)
        {
            surface.Smoothness = _Smoothness;

            // Use world position to create a hue value
            float hue = frac(input.worldPos.x * 0.1); // adjust 0.1 to change how rainbowy it looks
            float saturation = 1.0;
            float value = 1.0;

            float3 hsv = float3(hue, saturation, value);
            float3 rgb = hsv2rgb(hsv);

            surface.Albedo.rgb = rgb;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
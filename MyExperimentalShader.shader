Shader "Custom/MyExperimentalShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Saturation ("Saturation", Range(0,3)) = .5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _Saturation;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            // 1 --------------------------------------
            // Albedo comes from a texture tinted by color
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color; // original
    
            // 2 --------------------------------------
            // float2 uv = IN.uv_MainTex;
            // fixed4 c = tex2D (_MainTex, uv) * _Color; 

            // 3 --------------------------------------
            // float2 uv = IN.uv_MainTex;
            // uv.y += sin(uv.x * 6.2831) * .2;
            // fixed4 c = tex2D (_MainTex, uv) * _Color; 

            // 4 --------------------------------------
            // _Time = time elapsed since you pressed play
            // animates it
            float2 uv = IN.uv_MainTex;
            uv.y += sin(uv.x * 6.2831+_Time.y) * .2;
            fixed4 c = tex2D (_MainTex, uv) * _Color; 


            // 1 --------------------------------------
            // o.Albedo = c.rgb; // orig
            // o.Albedo = float3(1,.8,0); // makes yellow
            // o.Albedo = float3(1,1,0) * float3(1,0,0); // stays red 
            // o.Albedo = float3(1,1,0) + float3(0,0,1); // adding makes white plane
            // o.Albedo = 1-c; // inverted color

            // o.Albedo = c.b; // just one of the color channels, produced b/w image
            // o.Albedo = float3(c.b, c.b, c.b); //which is same as above

            // better way to get b/w is to avg
            // o.Albedo = (c.r + c.g + c.b) / 3;

            // to mix, use lerp (leanear interpolation)
            //  o.Albedo = lerp((c.r + c.g + c.b) / 3, c, .4);
            // o.Albedo = lerp((c.r + c.g + c.b) / 3, c, _Saturation); // saturation amount exposed as variable


            // 2 --------------------------------------
            // o.Albedo = uv.x; // gradient black to white

            // to control the saturation
            // float saturation = uv.x * _Saturation;
            // o.Albedo = lerp((c.r + c.g + c.b) / 3, c, saturation); 

            // sin
            // float saturation = sin(uv.x);
            // o.Albedo = lerp((c.r + c.g + c.b) / 3, c, saturation); 

            // sin multiplied to repeat 
            // float saturation = sin(uv.x * 6.2831);
            // o.Albedo = lerp((c.r + c.g + c.b) / 3, c, saturation); 

            // sin multiplied to repeat, then *.5 and +.5 to make it posiitive
            float saturation = sin(uv.x * 6.2831)*.5+.5;
            o.Albedo = lerp((c.r + c.g + c.b) / 3, c, saturation); 

            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

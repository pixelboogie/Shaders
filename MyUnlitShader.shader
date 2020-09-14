Shader "Custom/MyUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // vertex shader (called on every vertex)
            v2f vert (appdata v)
            {
                v2f o;

                // 1 No edits
    
                // 2
                // v.vertex.y += sin(v.vertex.x);

                // 3
                // v.vertex.y += sin(v.vertex.x+_Time.y)*.5;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // pixel shader / fragment shader
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // 1 - 4
                // fixed4 col = tex2D(_MainTex, i.uv);
                
                // 1, 2, 3
                // return col;

                // 4
                // float2 uv = i.uv - .5;
                // float a = _Time.y;
                // float2 p = float2(sin(a), cos(a))*.4;
                // float2 distort = uv-p;
                // float d = length(distort);
                // float m = smoothstep(.07, 0, d);
                // return m;

                // 5
                float2 uv = i.uv - .5;
                float a = _Time.y * 5;
                float2 p = float2(sin(a), cos(a))*.4;
                float2 distort = uv-p;
                float d = length(distort);
                float m = smoothstep(.2, -.2, d);
                distort = distort * 2 * m;

                fixed4 col = tex2D(_MainTex, i.uv+distort);

                // return float4(m*distort.x, m*distort.y, 0, 0);
                return col;



            }
            ENDCG
        }
    }
}

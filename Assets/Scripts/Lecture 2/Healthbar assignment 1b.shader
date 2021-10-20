Shader "Unlit/Healthbar assignment 1b"{
    Properties{
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health", Range(0,1)) = 1
    }
    SubShader{
        Tags { "RenderType"="Opaque" }

        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators{
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Health;

            Interpolators vert (MeshData v){
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float v){
                return (v-a)/(b-a);
            }

            float4 frag ( Interpolators i ) : SV_Target{
                //float4 col = tex2D(_MainTex, i.uv);


                float tHealthColor = InverseLerp( 0.2, 0.8, _Health);
                float3 healthbarColor = lerp( float3(1,0,0), float3(0,1,0), tHealthColor);
                
                float3 bgColor = float3(0,0,0);
                // float healthbarMask = _Health > i.uv.x;
                float healthbarMask = _Health > floor( i.uv.x * 8) / 8;

                // Mathf.lerp() // clamped
                // lerp() // unclamped
                
                float3 outColor = lerp( bgColor, healthbarColor, healthbarMask );
                return float4(outColor, 0);
                // return i.uv.x;
                // return float4(i.uv, 0, 0);
            }
            ENDCG
        }
    }
}

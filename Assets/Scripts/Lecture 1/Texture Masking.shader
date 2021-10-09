Shader "Unlit/Texture Masking"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Texture", 2D) = "white" {}
    }
    SubShader{
        Tags { "RenderType"="Opaque" }

        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define  TAU 6.28318530718

            struct MeshData{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators{
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _Pattern;
            
            Interpolators vert (MeshData v){
                Interpolators o;
                
                // o.worldPos = mul( UNITY_MATRIX_M, float4( v.vertex.xyz, 1 ) );

                o.worldPos = mul( UNITY_MATRIX_M, v.vertex ); // object to world
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float GetWave ( float coord ){
                float wave = cos( (coord - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                wave *= coord;
                return wave;
            }

            fixed4 frag (Interpolators i) : SV_Target{

                float2 topDownProjection = i.worldPos.xz;
                fixed4 moss = tex2D(_MainTex, topDownProjection);
                float pattern = tex2D( _Pattern, i.uv );

                
                return GetWave( pattern );
            }
            ENDCG
        }
    }
}

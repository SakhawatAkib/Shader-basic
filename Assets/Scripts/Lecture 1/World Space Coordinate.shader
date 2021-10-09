Shader "Unlit/World Space Coordinate"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v){
                Interpolators o;
                
                // o.worldPos = mul( UNITY_MATRIX_M, float4( v.vertex.xyz, 1 ) );

                o.worldPos = mul( UNITY_MATRIX_M, v.vertex ); // object to world
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x += _Time.y * 0.1;
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target{

                float2 topDownProjection = i.worldPos.xz;

                // return float4( topDownProjection, 0, 1 );

                // return float4( i.worldPos.xyz, 1 );

                
                fixed4 col = tex2D(_MainTex, topDownProjection);
                return col;
            }
            ENDCG
        }
    }
}

Shader "Unlit/v2f-normals"{
    Properties{
        _color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader{
        Tags{
            "RenderType"="Opaque"
        }
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            float4 _color;

            //automatically filled out by Unity
            struct MeshData{ // per-vertex mesh data
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators{
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                //float2 uv : TEXCOORD0;
                
            };


            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = v.normals; // just pass through
                return o;
            }
            
            fixed4 frag (Interpolators i) : SV_Target{
                
                return float4( i.normal, 1 ); // red
            }
            ENDCG
        }
    }
}
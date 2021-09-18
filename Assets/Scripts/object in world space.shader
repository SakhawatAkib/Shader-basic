Shader "Unlit/object-in-world-space"{
    Properties{
        _value("Value", Float) = 1.0
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

            float _value;

            //automatically filled out by Unity
            struct MeshData{ // per-vertex mesh data
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators{
                float4 vertex : SV_POSITION; // clip space position
                //float2 uv : TEXCOORD0;
            };


            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = v.vertex; // UnityObjectToClipPos(); // local space to clip space
                //o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target{
                
                return float4(0, 0, 1, 0.5); // red
            }
            ENDCG
        }
    }
}